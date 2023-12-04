module Refile
  module AttachmentHelper
    module FormBuilder
      def attachment_field(method, options = {})
        self.multipart = true
        @template.attachment_field(@object_name, method, **objectify_options(options))
      end
    end

    def attachment_field(object_name, method, **options)
      object = options[:object]
      options[:data] ||= {}

      definition = object.send(:"#{method}_attachment_definition")
      options[:accept] = definition.accept

      if options[:direct]
        url = Refile.attachment_upload_url(object, method, host: options[:host], prefix: options[:prefix])
        options[:data].merge!(direct: true, as: "file", url: url)
      end

      if options[:presigned] and definition.cache.respond_to?(:presign)
        url = Refile.attachment_presign_url(object, method, host: options[:host], prefix: options[:prefix])
        options[:data].merge!(direct: true, presigned: true, url: url)
      end

      options[:data][:reference] = SecureRandom.hex
      options[:include_hidden] = false

      attachment_cache_field(object_name, method, object: object, **options) + file_field(object_name, method, options)
    end
  end
end