class IssuesController < ApplicationController
  layout 'bar_layout'
  before_action :authenticate_user!

  before_action :set_issue, only: %i[ show edit update destroy ]

  # GET /issues or /issues.json
  def index
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @issues = @project.issues
    else
      @issues = Issue.all
      @issues = @project.issues
    end
  end
  

  # GET /issues/1 or /issues/1.json
  def show
    @project = Project.find(params[:project_id])
  end

  # GET /issues/new
  def new
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @user = current_user
      @issue = Issue.new
    else
      @user = current_user
      @issue = Issue.new
    end

  end

  # GET /issues/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
  end
  # POST /issues or /issues.json
  def create
    @project = Project.find(params[:project_id])
    @issue = @project.issues.build(issue_params)
    @issue.user_id = current_user.id
  
    respond_to do |format|
      if @issue.save
        TimelineEvent.create(:issue => @issue, :user => current_user, :message => "has created a new issue:")
        format.html { redirect_to project_issues_path(@project), notice: "Issue was successfully created." }
        format.json { render :show, status: :created, location: @issue }
      else
        format.html do
          render :new, status: :unprocessable_entity
        end
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end
  
  

  # PATCH/PUT /issues/1 or /issues/1.json
  def update
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    if @issue.update(issue_params)
      TimelineEvent.create(:issue => @issue, :user => current_user, :message => "has updated the state of the issue")
      redirect_to project_issues_path(@project)
    else
      render 'edit'
    end
  end

  # DELETE /issues/1 or /issues/1.json
  def destroy
    @issue.destroy

    respond_to do |format|
      format.html { redirect_to issues_url, notice: "Issue was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def issue_params
      params.require(:issue).permit(:subject, :description, :issue_type, :severity, :priority, :blocked, :status, :limitDate, tag_ids: [])
    end    
end
