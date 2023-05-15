class AttachmentSerializer < ActiveModel::Serializer
    attributes :id, :name, :path

    def name
        object.blob.filename
    end

    def path
        Rails.application.routes.url_helpers.rails_blob_path(object, only_path: true, disposition: "attachment")
    end


end