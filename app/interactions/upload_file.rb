class UploadFile < ActiveInteraction::Base
    file :uploaded_file

    def execute
        if uploaded_file.is_a?(ActionDispatch::Http::UploadedFile)
            unique_filename = uploaded_file.original_filename

            prefix_dir = SecureRandom.hex(10)

            upload_directory = Rails.root.join('public', 'uploads', prefix_dir)

            FileUtils.mkdir_p(upload_directory) unless File.directory?(upload_directory)

            file_path = File.join(upload_directory, unique_filename)

            File.open(file_path, 'wb') do |file|
                file.write(uploaded_file.read)
            end

            file_url = "#{ENV['BASE_URL']}/uploads/#{prefix_dir}/#{unique_filename}"

            return { file_url: file_url }
        else
            errors.add(:uploaded_file, 'Invalid or missing uploaded file')
        end
    end
end