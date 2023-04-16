class IssuesController < ApplicationController
  layout 'bar_layout', except: [:date, :add_watchers_view, :change_assigned_view]
  before_action :authenticate_user!

  before_action :set_issue, only: %i[ show edit update destroy ]

  protect_from_forgery with: :null_session

  
  
  # GET /issues or /issues.json
  def index
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @issues = if params[:search].present?
        @project.issues.where("subject LIKE ?", "%#{params[:search]}%")
      else
        @issues = @project.issues.all
      end
    else
      @issues = Issue.all
    end

  if params[:sort_by] == 'issue_type'
    @issues = @issues.order(issue_type: :asc)
  end
  if params[:sort_by] == 'severity'
    @issues = @issues.order(severity: :asc)
  end
  if params[:sort_by] == 'priority'
    @issues = @issues.order(priority: :asc)
  end
 if params[:sort_by] == 'subject'
    @issues = @issues.order(subject: :asc)
  end
  if params[:sort_by] == 'status'
    @issues = @issues.order(status: :asc)
  end
  if params[:sort_by] == 'updated_at'
    @issues = @issues.order(updated_at: :asc)
  end
  if params[:sort_by] == 'assigned_to'
    @issues = @issues.joins(:assigned_to).order('users.username ASC')
  end  
  
  end
  

  # GET /issues/1 or /issues/1.json
  def show
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @watchedIssues = WatchedIssue.where(issue: @issue)
    @comments = Comment.where(issue: @issue).order(created_at: :desc)
    @activities = TimelineEvent.where(issue: @issue)
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
  def new_bulk
    @project = Project.find(params[:project_id])
    @user = current_user
    @issue = Issue.new
  end
  
  def bulk_create
    issue_names = params[:issue_names].split("\n")
    @project = Project.find(params[:project_id])

    issue_names.each do |issue_name|
      @issue = @project.issues.build()
      @issue.user_id = current_user.id
      @issue.assigned_to_id = current_user.id
      @issue.subject = issue_name
        if @issue.save
          TimelineEvent.create(:issue => @issue, :user => current_user, :message => "created a new issue")
        end
    end
  
    redirect_to project_issues_path(@project)
  end
  
  

  # GET /issues/1/edit
  def edit
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
  end

  def date
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
  end

  def add_watchers_view
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @users = User.all
    @possibleWatchers = @users
    WatchedIssue.where(issue: @issue).all.each do |curentWatcher|
      @possibleWatchers = @possibleWatchers - [curentWatcher.user]
    end
  end

  def change_assigned_view
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @users = User.all
    @possibleAssigned = @users
    if !@issue.assigned_to.nil?
      @possibleAssigned = @possibleAssigned - [@issue.assigned_to]
    end
  end

  def activities
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @watchedIssues = WatchedIssue.where(issue: @issue)
    @activities = TimelineEvent.where(issue: @issue).order(created_at: :desc)
    @comments = Comment.where(issue: @issue)
  end

  # POST /issues or /issues.json
  def create
    @project = Project.find(params[:project_id])
    @issue = @project.issues.build(issue_params)
    @issue.user_id = current_user.id
    @issue.assigned_to_id = current_user.id
  
    respond_to do |format|
      if @issue.save
        TimelineEvent.create(:issue => @issue, :user => current_user, :message => "created a new issue")
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
      TimelineEvent.create(:issue => @issue, :user => current_user, :message => "updated the issue")
      redirect_to project_issues_path(@project)
    else
      render 'edit'
    end
  end

  def update_description
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    if @issue.update(issue_params)
      TimelineEvent.create(:issue => @issue, :user => current_user, :message => "updated the description")
    end
    redirect_to '/projects/' + @project.id.to_s + '/issues/' + @issue.id.to_s
  end

  def update_status
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @currentStatus = @issue.status
    if @issue.update(issue_params)
      TimelineEvent.create(:issue => @issue, :user => current_user, :message => "changed the status from " + @currentStatus.capitalize() + " to " + @issue.status.capitalize())
    end
    redirect_to '/projects/' + @project.id.to_s + '/issues/' + @issue.id.to_s
  end

  def update_type
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @currentType = @issue.issue_type
    if @issue.update(issue_params)
      TimelineEvent.create(:issue => @issue, :user => current_user, :message => "changed the type from " + @currentType.capitalize() + " to " + @issue.issue_type.capitalize())
    end
    redirect_to '/projects/' + @project.id.to_s + '/issues/' + @issue.id.to_s
  end

  def update_severity
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @currentSeverity = @issue.severity
    if @issue.update(issue_params)
      TimelineEvent.create(:issue => @issue, :user => current_user, :message => "changed the severity from " + @currentSeverity.capitalize() + " to " + @issue.severity.capitalize())
    end
    redirect_to '/projects/' + @project.id.to_s + '/issues/' + @issue.id.to_s
  end

  def update_priority
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @currentPriority = @issue.priority
    if @issue.update(issue_params)
      TimelineEvent.create(:issue => @issue, :user => current_user, :message => "changed the priority from " + @currentPriority.capitalize() + " to " + @issue.priority.capitalize())
    end
    redirect_to '/projects/' + @project.id.to_s + '/issues/' + @issue.id.to_s
  end

  def update_block
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @issue.update_attribute(:blocked, !@issue.blocked)
    if @issue.blocked?
      TimelineEvent.create(:issue => @issue, :user => current_user, :message => "blocked the issue")
    else
      TimelineEvent.create(:issue => @issue, :user => current_user, :message => "unblocked the issue")
    end
    redirect_to '/projects/' + @project.id.to_s + '/issues/' + @issue.id.to_s
  end

  def update_deadline
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @issue.update_attribute(:limitDate, params[:limitDate])
    TimelineEvent.create(:issue => @issue, :user => current_user, :message => "changed the deadline")
    redirect_to '/projects/' + @project.id.to_s + '/issues/' + @issue.id.to_s
  end

  def add_watcher
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @watcher = User.find(params[:user_id])
    WatchedIssue.create(:issue => @issue, :user => @watcher)
    redirect_to '/projects/' + @project.id.to_s + '/issues/' + @issue.id.to_s
  end

  def add_comment
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    Comment.create(:issue => @issue, :user => current_user, :text => params[:text])
    TimelineEvent.create(:issue => @issue, :user => current_user, :message => "wrote a new comment")
    redirect_to '/projects/' + @project.id.to_s + '/issues/' + @issue.id.to_s
  end

  def change_assigned
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @assigned = User.find(params[:user_id])
    @issue.assigned_to = @assigned
    @issue.save
    redirect_to '/projects/' + @project.id.to_s + '/issues/' + @issue.id.to_s
  end

  def attach_files
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @files = params[:files]
    @issue.files.attach(@files)
    TimelineEvent.create(:issue => @issue, :user => current_user, :message => "attached " + @files.length.to_s + " new file/s")
    redirect_to '/projects/' + @project.id.to_s + '/issues/' + @issue.id.to_s
  end

  # DELETE /issues/1 or /issues/1.json
  def destroy
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @issue.timeline_events.clear
    @issue.watched_issue.clear
    @issue.tags.clear
    @issue.comments.clear
    @issue.delete

    respond_to do |format|
      format.html { redirect_to '/projects/' + @project.id.to_s + '/issues', notice: "Issue was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def delete_deadline
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @issue.update_attribute(:limitDate, nil)
    TimelineEvent.create(:issue => @issue, :user => current_user, :message => "deleted the deadline")
    redirect_to '/projects/' + @project.id.to_s + '/issues/' + @issue.id.to_s
  end

  def delete_watcher
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @watcher = User.find(params[:user_id])
    @watchedIssue = WatchedIssue.find_by(issue: @issue, user: @watcher)
    if @watchedIssue.delete
      redirect_to '/projects/' + @project.id.to_s + '/issues/' + @issue.id.to_s
    else
      raise "error"
    end
  end

  def delete_attachment
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @file = @issue.files.find(params[:file_id])
    @file.purge
    TimelineEvent.create(:issue => @issue, :user => current_user, :message => "deleted an attachment")
    redirect_to '/projects/' + @project.id.to_s + '/issues/' + @issue.id.to_s
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def issue_params
      params.require(:issue).permit(:subject, :description, :issue_type, :severity, :priority, :blocked, :status, :limitDate, :assigned_to_id, tag_ids: [], files: [])
    end    
end
