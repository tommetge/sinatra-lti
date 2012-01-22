module Sinatra
  module SinatraLti
    module Helpers
      def require_lti!
        unless session['resource_link_id']
          redirect '/lti_required'
        end
      end

      # these methods give access to LTI-provided user data
      def username
        session['lis_person_name_full'] || 'Student'
      end
    end
  end
  helpers SinatraLti::Helpers
end