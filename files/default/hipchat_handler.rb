require 'chef'
require 'chef/handler'

begin
  require 'hipchat'
rescue LoadError
  Chef::Log.debug('Chef hipchat_handler requires \'hipchat\' gem')
end

require 'timeout'

class Chef
  class Handler
    class Hipchat < Chef::Handler
      attr_reader :server_url, :room, :auth_token, :config, :timeout, :report_success, :notify_users, :detail_level

      def initialize(config = {})
        @config = config.dup
        @server_url = @config.delete(:server_url) || 'https://api.hipchat.com'
        @room = @config.delete(:room)
        @auth_token = @config.delete(:auth_token)
        @timeout = @config.delete(:timeout) || 10
        @report_success = @config.delete(:report_success) || false
        @notify_users = @config.delete(:notify_users) || true
        @detail_level = @config.delete(:detail_level) || 'basic'
        @emoji_url = @config.delete(:emoji_url) || nil
      end

      def report
        Timeout.timeout(@timeout) do
          Chef::Log.debug('Sending report to Hipchat')
          if run_status.success?
            hipchat_message(success_msg) if @report_success
          else
            hipchat_message(failure_msg)
          end
        end
      rescue StandardError => e
        Chef::Log.debug("Failed to send message to Hipchat: #{e.message}")
      end

      private

      def run_status_detail(detail_level)
        case detail_level
        when 'basic'
          return
        when 'elapsed'
          "(#{run_status.elapsed_time} seconds). #{updated_resources.count} resources updated" unless updated_resources.nil?
        when 'resources'
          "(#{run_status.elapsed_time} seconds). #{updated_resources.count} resources updated\n#{updated_resources.join(', ')}" unless updated_resources.nil?
        else
          return
        end
      end

      def failure_msg
        %(#{hipchat_emoji}
    <strong>Chef client run #{run_status_human_readable} on #{run_status.node.name} #{run_status_detail(@detail_level)}</strong><br/>
    <pre>#{run_status.exception}</pre>)
      end

      def success_msg
        %(<strong>Chef client run #{run_status_human_readable} on #{run_status.node.name} #{run_status_detail(@detail_level)}</strong>)
      end

      def hipchat_emoji
        if @emoji_url.nil?
          ''
        else
          %(#{'<img src=' + @emoji_url + '> '})
        end
      end

      def hipchat_message(content)
        hipchat = HipChat::Client.new(
          @auth_token,
          :api_version => 'v2',
          :server_url => @server_url
        )

        hipchat[@room].send(
          'chef-client',
          content,
          :notify => @notify_users,
          :message_format => 'html'
        )
      end

      def run_status_human_readable
        run_status.success? ? 'succeeded' : 'failed'
      end
    end
  end
end
