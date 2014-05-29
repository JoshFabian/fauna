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
          [:bytes, :etag, :format, :height, :public_id, :resource_type, :version, :width]
        end

        def user_avatar_image_params(hash)
          ActionController::Parameters.new(hash).permit(permitted_image_params)
        end

        def user_cover_image_params(hash)
          ActionController::Parameters.new(hash).permit(permitted_image_params)
        end

        def user_params
          permit_params = [:bio, :email, :first_name, :handle, :last_name, :password, :password_confirmation,
            :website]
          ActionController::Parameters.new(params).required(:user).permit(permit_params)
        end
      end

      desc "List users"
      get '' do
        @users = User.order('id desc').page(@page).per(@per)
        logger.post("tegu.api", log_data.merge({event: 'users.list'}))
        {total: User.count, users: @users.map{ |o| {id: o.id, handle: o.handle} }}
      end

      desc "Update user"
      put ':id' do
        puts "[user params]:#{params}"
        @user = User.find(params.id)
        error! '', 401 if @user != current_user
        if params.user.password.blank? and params.user.password_confirmation.blank?
          params.user.delete(:password)
          params.user.delete(:password_confirmation)
        end
        @user.update_attributes(user_params)
        if params.avatar_image_params.present?
          puts "*** adding avatar image:#{params.avatar_image_params}"
          begin
            @user.create_avatar_image!(user_avatar_image_params(JSON.parse(params.avatar_image_params)))
          rescue Exception => e
          end
        end
        if params.cover_image_params.present?
          params.cover_image_params.select{ |s| s.present? }.each do |s|
            puts "*** adding cover image:#{s}"
            begin
              @user.cover_images.create!(user_cover_image_params(JSON.parse(s)))
            rescue Exception => e
            end
          end
        end
        error! 'Invalid User', 406 if @user.invalid?
        logger.post("tegu.api", log_data.merge({event: 'user.update', user_id: @user.id}))
        {user: @user}
      end

    end

  end
end