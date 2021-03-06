class ChannelsController < ApplicationController
  def show
    @channel = Channel.find(params[:channel])
    @episodes = @channel.episodes.order_by(published_at: :desc).page(page).per(5).decorate
  end

  def list
    @channels = Channel.listed.order_by(created_at: :desc).page(page).per(24).decorate
  end

  def search
    @channels = Channel.listed.search(search_term).limit(24).page(page).decorate

    render :list
  end

  private

  def search_term
    params[:term]
  end

  def page
    params[:page]
  end
end
