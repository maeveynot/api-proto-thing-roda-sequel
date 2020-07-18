module Rack
  module JWT
    class Auth
      def check_exclude_type!
        nil
      end
      def path_matches_excluded_path?(env)
        @exclude.any? do |ex|
          case ex
          when String; env['PATH_INFO'].start_with?(ex)
          when Regexp; env['PATH_INFO'] =~ ex
          end
        end
      end
    end
  end
end
