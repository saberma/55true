# activemodel的实体属性名称统一从formtastic中的label获取
module Formtastic
  module I18n
    module Naming

      def self.included(base)
        base.extend(ClassMethods)
      end

      protected
      module ClassMethods
        def human_attribute_name(attribute, options = {})
          I18n.t("labels.#{model_name.underscore}.#{attribute}")
        end
      end
      
    end
  end
end
