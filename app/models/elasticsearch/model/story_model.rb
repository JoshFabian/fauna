module Elasticsearch
  module Model

    class StoryModel < Array
      def initialize(models=[])
        models = models.empty? ? [Category, Listing] : models
        super(models)
      end

      def client
        Elasticsearch::Model.client
      end

      def ancestors
        []
      end

      def default_per_page
        10
      end

      def inspect
        "StoryModel: #{super}"
      end

      def index_name
        map { |m| m.index_name }
      end

      def document_type
        map { |m| m.document_type }
      end

      # def __searchable_models
      #   Object.constants
      #     .select { |c| Kernel.const_get(c).respond_to?(:__elasticsearch__) }
      #     .map    { |c| c.is_a?(Class) ? c : Kernel.const_get(c) }
      # end
    end

  end
end