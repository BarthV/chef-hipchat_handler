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
      attr_reader :team, :api_key, :config, :timeout, :fail_only, :detail_level

      def initialize(config = {})
        @config = config.dup
        @room = @config.delete(:room)
        @auth_token = @config.delete(:auth_token)
        @timeout = @config.delete(:timeout) || 10
        @fail_only = @config.delete(:fail_only) || true
        @detail_level = @config.delete(:detail_level) || 'basic'
        @emoji_url = @config.delete(:emoji_url) || nil
      end

      def report
        Timeout.timeout(@timeout) do
          Chef::Log.debug('Sending report to Hipchat')
          if fail_only
            hipchat_message(failure_msg) unless run_status.success?
          else
            hipchat_message(succes_msg)
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
          :api_version => 'v2'
        )

        File.write('/tmp/debug1', failure_msg)

        hipchat[@room].send(
          'chef-client',
          content,
          :notify => true,
          :message_format => 'html'
        )
      end

      def run_status_human_readable
        run_status.success? ? 'succeeded' : 'failed'
      end
    end
  end
end
