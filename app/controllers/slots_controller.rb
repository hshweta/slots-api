class SlotsController < ApplicationController
    before_action :set_slot, only: [:show, :destroy]

    # GET /slots
    def index
        @slots = Slot.all
        render json: @slots
    end

    # GET /slots/:id
    def show
        render json: @slot
    end

    # POST /slots
    def create
        @slot = Slot.new(slot_params)

        if @slot.save
            render json: @slot, status: :created, location: @slot
        else
            render json: @slot.errors, status: :unprocessable_entity
        end
    end

    # DELETE /slots/1
    def destroy
        @slot.destroy
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_slot
        @slot = Slot.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def slot_params
        params.require(:slot).permit(:total_capacity, :start_time, :end_time)
    end
end