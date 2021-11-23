class UsersController < ApplicationController
  def index
    @batch = Batch.find(params[:batch_id])

    @students = []
    User.where(admin: false).each do |student|
      @batch.bookings.each do |booking|
        if booking.user_id == student.id
          @students << student
        end
      end
    end
  end
end
