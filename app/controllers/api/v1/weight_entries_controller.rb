class Api::V1::WeightEntriesController < ApplicationController
  before_action :authorize

  def index
    entries = current_user.weight_entries.order(date: :desc)
    render json: entries
  end

  def create
    entry = current_user.weight_entries.new(weight_entry_params)
    if entry.save
      render json: entry, status: :created
    else
      render json: { errors: entry.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def weight_entry_params 
    params.require(:weight_entry).permit(:weight, :date)
  end
end
