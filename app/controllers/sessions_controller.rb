class SessionsController < ApplicationController
  def index
    if session[:researcher_id]
      redirect_to results_path
    elsif session[:user_id]
      redirect_to user_scenarios_path
    end
    render :layout => false
  end

  def create
    email = params[:login][:email]
    type = params[:login][:type]
    if type == 'tester'
      user = User.find_by(email: email)
      if user
        session[:user_id] = user.id
        redirect_to user_scenarios_path
        return
      else
        flash[:error] = 'There was an error with your tester email.'
      end
    elsif type == 'researcher'
      researcher = Researcher.find_by(email: email)
      if researcher
        session[:researcher_id] = researcher.id
        redirect_to results_path
        return
      else
        flash[:error] = 'There was an error with your researcher email.'
      end
    else
      flash[:error] = 'There was an error with your type.'
    end
    redirect_to login_path
  end

  def destroy
    session[:user_id] = nil
    session[:researcher_id] = nil
    redirect_to root_path
  end
end
