class ActiveRecord::Base
  module MongoidBridge
    extend ActiveSupport::Concern

    included do
      def self.has_many_documents(association_name)
        class_eval <<-EOS
          def #{ association_name }
            klass_name = #{ association_name.to_s.singularize.classify }
            klass_name.where(#{ name.underscore }_id: id)
          end
        EOS
      end

      def self.has_one_document(association_name)
        class_eval <<-EOS
          def #{ association_name }
            klass_name = #{ association_name.to_s.classify }
            klass_name.where(#{ name.underscore }_id: id).first
          end
        EOS
      end
    end
  end
end

module Mongoid::ActiveRecordBridge
  extend ActiveSupport::Concern

  included do
    def self.belongs_to_active_record(association_name, options={})
      association_class = options[:class_name] || association_name.to_s.singularize.classify
      # index(#{ association_name }_id: 1)
      class_eval <<-EOS
        field :#{ association_name }_id, type: Integer

        def #{ association_name }
          @#{ association_name } ||= #{ association_class }.where(id: #{ association_name }_id).first
        end

        def #{ association_name }=(object)
          @#{ association_name } = object
          self.#{ association_name }_id = object.try :id
        end
      EOS
    end
  end
end