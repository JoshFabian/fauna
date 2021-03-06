module Endpoints
  class PostApi < Grape::API
    format :json

    rescue_from :all do |e|
      rack_response({ status: "error", error: e.message })
    end

    resource :posts do
      after_validation do
        @post = Post.find(params.id) if params.id.present?
      end

      helpers do
        def post_params
          ActionController::Parameters.new(params).required(:post).permit(:body, :facebook_share)
        end

        def comment_params
          ActionController::Parameters.new(params).required(:comment).permit(:body)
        end
      end

      desc "Create post"
      post '' do
        authenticate!
        post = current_user.posts.create(post_params)
        post.should_update_index! if post.persisted?
        logger.post("tegu.api", log_data.merge({event: 'post.create'}))
        {post: post}
      end

      desc "Create post comment"
      post ':id/comments' do
        authenticate!
        comment = current_user.comments.create(comment_params.merge(commentable: @post))
        logger.post("tegu.api", log_data.merge({event: 'post.comment.create', post_id: @post.id}))
        {post: @post.as_json().merge(comment: comment)}
      end

      desc "Create post like"
      put ':id/toggle_like' do
        authenticate!
        PostLike.toggle_like!(@post, current_user)
        logger.post("tegu.api", log_data.merge({event: 'post.toggle_like', post_id: @post.id}))
        {post: @post.as_json()}
      end

      desc "Returns 1 if the post should be shared but requires facebook permissions"
      get ':id/share/facebook/auth' do
        acl_manage!(on: @post)
        auth = PostShare.facebook_share_permissions_required?(@post) ? 1 : 0
        {post: @post, auth: auth}
      end

      desc "Share post on facebook"
      put ':id/share/facebook' do
        acl_manage!(on: @post)
        begin
          raise Exception, "post already facebook shared" if @post.facebook_shared?
          PostShare.facebook_share!(@post)
          event = 'facebook_share'
          logger.post("tegu.api", log_data.merge({event: 'post.share.facebook', post_id: @post.id}))
        rescue Exception => e
          logger.post("tegu.api", log_data.merge({event: 'post.share.facebook.exception', post_id: @post.id,
            message: e.message}))
          error!("Share exception: #{e.message}", 401)
        end
        {post: @post, event: event}
      end
    end # posts
  end
end