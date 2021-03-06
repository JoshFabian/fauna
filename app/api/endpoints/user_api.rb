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
          permit_params = [:about, :city, :state_code, :email, :first_name, :handle, :last_name,
            :password, :password_confirmation, :reset_password_token, :phone, :website, :welcome_message]
          ActionController::Parameters.new(params).required(:user).permit(permit_params)
        end
      end

      desc "List users"
      get '' do
        users = User.order('id desc').page(@page).per(@per)
        logger.post("tegu.api", log_data.merge({event: 'users.list'}))
        {total: User.count, users: users.map{ |o| {id: o.id, handle: o.handle} }}
      end

      desc "Get user"
      get ':id' do
        authenticate!
        logger.post("tegu.api", log_data.merge({event: 'user.get'}))
        {user: @user}
      end

      desc "Get user verified status"
      get ':id/verified(/:name)' do
        authenticate!
        if params.name.blank?
          verified = @user.verified?
        else
          verified = @user.send("#{params.name}_verified?")
        end
        logger.post("tegu.api", log_data.merge({event: 'user.verified'}))
        {user: {id: @user.id, verified: verified}}
      end

      desc "Send password reset email"
      put 'send_reset_password' do
        user = User.find_by_email(params.email)
        user.send_reset_password_instructions if user
        logger.post("tegu.api", log_data.merge({event: 'user.send_reset_password'}))
        {user: user.as_json(only: [:id])}
      end

      desc "Reset password with password reset token"
      put 'reset_password' do
        user = User.reset_password_by_token(user_params)
        logger.post("tegu.api", log_data.merge({event: 'user.reset_password'}))
        {user: user.as_json(only: [:id])}
      end

      desc "Update user"
      put ':id' do
        authenticate!
        error! '', 401 if @user != current_user
        if params.user.password.blank? and params.user.password_confirmation.blank?
          params.user.delete(:password)
          params.user.delete(:password_confirmation)
        end
        @user.update(user_params)
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
        authenticate!
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
        {user: @user.as_json().merge(cover_images: @images.as_json(only: [:id, :position]))}
      end

      desc "Add user listing credits"
      put ':id/credits/add/:number' do
        authenticate!
        @user.increment!(:listing_credits, 1)
        {user: @user.as_json(only: [:id, :listing_credits])}
      end

      # user settings

      desc "Reset user paypal email verification"
      put ':id/paypal_email/reset' do
        authenticate!
        @user.update_attributes(paypal_email: nil)
        logger.post("tegu.api", log_data.merge({event: 'user.reset_paypal_email', user_id: @user.id}))
        {user: @user.as_json(only: [:id, :paypal_email]), event: 'reset_paypal_email'}
      end

      desc "Reset user phone number verification"
      put ':id/phone_number/reset' do
        authenticate!
        @user.phone_tokens.verified.each { |o| o.reset! }
        logger.post("tegu.api", log_data.merge({event: 'user.reset_phone_number', user_id: @user.id}))
        {user: @user.as_json(only: [:id]), event: 'reset_phone_number'}
      end

      # user follow

      desc "Get users following list"
      get ':id/following' do
        following = @user.following
        logger.post("tegu.api", log_data.merge({event: 'user.following', user_id: @user.id}))
        {user: @user.as_json(only: [:id]).merge(following: following.as_json)}
      end

      desc "Get users followers list"
      get ':id/followers' do
        followers = @user.followers
        logger.post("tegu.api", log_data.merge({event: 'user.followers', user_id: @user.id}))
        {user: @user.as_json(only: [:id]).merge(followers: followers.as_json)}
      end

      desc "Get user following state"
      get ':id/following/:follow_ids', requirements: {follow_ids: /([0-9]+)(,[0-9]+)*/}  do
        follow_ids = params[:follow_ids].split(',').map(&:to_i)
        states = follow_ids.inject([]) do |states, follow_id|
          state = UserFollow.following?(@user, follow_id) ? 'following' : 'not-following'
          states.push({follow_id: follow_id, follow_state: state})
          states
        end
        logger.post("tegu.api", log_data.merge({event: 'user.following', user_id: @user.id, follow_ids: follow_ids}))
        {user: @user.as_json(only: [:id]).merge(following: states)}
      end

      desc "Toggle user following state"
      put ':id/toggle_follow/:follow_id', requirements: {} do
        mash = UserFollow.toggle_follow!(@user, params[:follow_id])
        logger.post("tegu.api", log_data.merge({event: 'user.toggle_follow', user_id: @user.id, event: mash.event}))
        {user: @user.as_json(only: [:id]).merge(follow_id: params[:follow_id].to_i, follow_event: mash.event,
          follow_count: mash[:count])}
      end
    end

  end
end