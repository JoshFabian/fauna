module Endpoints
  class UserApi < Grape::API
    format :json

    rescue_from :all do |e|
      rack_response({ status: "error", error: e.message })
    end

    resource :users do
      before do
        @user = User.find(params[:id]) if params[:id].present?
      end

      helpers do
        def permitted_image_params
          [:bytes, :etag, :format, :height, :position, :public_id, :resource_type, :version, :width]
        end

        def user_avatar_image_params(hash)
          ActionController::Parameters.new(hash).permit(permitted_image_params)
        end

        def user_cover_image_params(hash)
          ActionController::Parameters.new(hash).permit(permitted_image_params)
        end

        def user_params
          permit_params = [:about, :city, :state_code, :email, :first_name, :handle, :last_name, :password,
            :password_confirmation, :phone, :website, :welcome_message]
          ActionController::Parameters.new(params).required(:user).permit(permit_params)
        end
      end

      desc "List users"
      get '' do
        @users = User.order('id desc').page(@page).per(@per)
        logger.post("tegu.api", log_data.merge({event: 'users.list'}))
        {total: User.count, users: @users.map{ |o| {id: o.id, handle: o.handle} }}
      end

      desc "Returns user verified status"
      get ':id/verified(/:name)' do
        user = User.find(params[:id])
        if params.name.blank?
          verified = user.verified?
        else
          verified = user.send("#{params.name}_verified?")
        end
        {user: {id: user.id, verified: verified}}
      end

      desc "Update user"
      put ':id' do
        # puts "[params]:#{params}"
        @user = User.find(params.id)
        error! '', 401 if @user != current_user
        if params.user.password.blank? and params.user.password_confirmation.blank?
          params.user.delete(:password)
          params.user.delete(:password_confirmation)
        end
        @user.update_attributes(user_params)
        if params.avatar_image_params.present?
          # puts "*** adding avatar image:#{params.avatar_image_params}"
          begin
            @user.create_avatar_image!(user_avatar_image_params(JSON.parse(params.avatar_image_params)))
          rescue Exception => e
          end
        end
        if params.cover_image_params.present?
          params.cover_image_params.select{ |s| s.present? }.each do |s|
            # puts "*** adding cover image:#{s}"
            begin
              @user.cover_images.create!(user_cover_image_params(JSON.parse(s)))
            rescue Exception => e
            end
          end
        end
        if params.cover_image_deletes.present?
          params.cover_image_deletes.split(',').each do |id|
            # puts "*** removing cover image:#{id}"
            begin
              image = @user.cover_images.find_by_id(id)
              @user.cover_images.destroy(image)
            rescue Exception => e
            end
          end
        end
        error! 'Invalid User', 406 if @user.invalid?
        logger.post("tegu.api", log_data.merge({event: 'user.update', user_id: @user.id}))
        {user: @user}
      end

      desc "Update cover image positions"
      put ':id/cover_images/sort' do
        @user = User.find(params.id)
        if params.cover_images.present?
          params.cover_images.each do |object|
            begin
              object = object.last if object.is_a?(Array)
              image = @user.cover_images.find(object.id)
              image.update_attributes(position: object.position)
            rescue Exception => e
            end
          end
        end
        @images = @user.cover_images
        logger.post("tegu.api", log_data.merge({event: 'user.cover_images.update', user_id: @user.id}))
        {user: {id: @user.id, cover_images: @images.as_json(only: [:id, :position])}}
      end

      desc "Add user listing credits"
      put ':id/credits/add/:number' do
        @user = User.find(params.id)
        @user.increment!(:listing_credits, 1)
        {user: @user.as_json(only: [:id, :listing_credits])}
      end
    end

  end
end