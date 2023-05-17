class IssuesController < ApplicationController
  layout 'bar_layout', except: [:date, :add_watchers_view, :change_assigned_view]


  protect_from_forgery with: :null_session

  def filter
    @project = get_project
  end

  
  
  # GET /issues or /issues.json
  def index
    @project = get_project
    @issues = if params[:search].present?
      @project.issues.where("subject LIKE ? OR description LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
    else
      @project.issues.all
    end
  
    if params[:issue_type].present?
      @issues = @issues.where(issue_type: params[:issue_type])
    end
  
    if params[:severity].present?
      @issues = @issues.where(severity: params[:severity])
    end
  
    if params[:priority].present?
      @issues = @issues.where(priority: params[:priority])
    end
  
    if params[:status].present?
      @issues = @issues.where(status: params[:status])
    end
  
    if params[:sort_by] == 'issue_type'
      @issues = @issues.order(issue_type: :asc)
    elsif params[:sort_by] == 'severity'
      @issues = @issues.order(severity: :asc)
    elsif params[:sort_by] == 'priority'
      @issues = @issues.order(priority: :asc)
    elsif params[:sort_by] == 'subject'
      @issues = @issues.order(subject: :asc)
    elsif params[:sort_by] == 'status'
      @issues = @issues.order(status: :asc)
    elsif params[:sort_by] == 'updated_at'
      @issues = @issues.order(updated_at: :asc)
    elsif params[:sort_by] == 'assigned_to'
      @issues = @issues.joins(:assigned_to).order('users.username ASC')
    end
    respond_to do |format|
      format.json { render json: ActiveModel::Serializer::CollectionSerializer.new(@issues, serializer: IssueBriefSerializer) }
      format.html { render :index }
    end
  end
  
  

  # GET /issues/1 or /issues/1.json
  def show
    @project = get_project
    @issue = get_issue
    @watchedIssues = WatchedIssue.where(issue: @issue)
    @comments = Comment.where(issue: @issue).order(created_at: :desc)
    @activities = TimelineEvent.where(issue: @issue)
    respond_to do |format|
      format.json { render json: @issue, serializer: IssueSerializer }
      format.html { render :show }
    end
  end

  # GET /issues/new
  def new
    if params[:project_id]
      @project = get_project
      @user = current_user
      @issue = Issue.new
    else
      @user = current_user
      @issue = Issue.new
    end

  end
  def new_bulk
    @project = get_project
    @user = current_user
    @issue = Issue.new
  end
  
  def bulk_create
    issue_names = params[:issue_names].split("\n")
    @project = get_project
    user = get_user
    issue_names.each do |issue_name|
      @issue = @project.issues.build()
      @issue.user_id = user.id
      @issue.assigned_to_id = user.id
      @issue.subject = issue_name
        if @issue.save
          TimelineEvent.create(:issue => @issue, :user => user, :message => "created a new issue")
        end
    end
    
    respond_to do |format|
      format.json { render json: ActiveModel::Serializer::CollectionSerializer.new(@project.issues, serializer: IssueBriefSerializer) }
      format.html { redirect_to project_issues_path(@project) }
    end
  end
  
  

  # GET /issues/1/edit
  def edit
    @project = get_project
    @issue = get_issue
  end

  def date
    @project = get_project
    @issue = get_issue
  end

  def add_watchers_view
    @project = get_project
    @issue = get_issue
    @users = User.all
    @possibleWatchers = @users
    WatchedIssue.where(issue: @issue).all.each do |curentWatcher|
      @possibleWatchers = @possibleWatchers - [curentWatcher.user]
    end
  end

  def change_assigned_view
    @project = get_project
    @issue = get_issue
    @users = User.all
    @possibleAssigned = @users
    if !@issue.assigned_to.nil?
      @possibleAssigned = @possibleAssigned - [@issue.assigned_to]
    end
  end

  def activities
    @project = get_project
    @issue = get_issue
    @watchedIssues = WatchedIssue.where(issue: @issue)
    @activities = TimelineEvent.where(issue: @issue).order(created_at: :desc)
    @comments = Comment.where(issue: @issue)
  end

  # POST /issues or /issues.json
  def create
    @project = get_project
    @issue = @project.issues.build(issue_params)
    user = get_user
    @issue.user_id = user.id
    @issue.assigned_to_id = user.id
    respond_to do |format|
      if @issue.save
        TimelineEvent.create(:issue => @issue, :user => user, :message => "created a new issue")
        format.json { render json: @issue, status: :created, serializer: IssueSerializer }
        format.html { redirect_to project_issues_path(@project), notice: "Issue was successfully created." }
      else
        format.json { render json: @issue.errors, status: :unprocessable_entity }
        format.html do
          render :new, status: :unprocessable_entity
        end
      end
      puts @issue.id
    end
  end
  
  

  # PATCH/PUT /issues/1 or /issues/1.json
  def update
    @project = get_project
    @issue = get_issue
    user = get_user
    respond_to do |format|
      if @issue.update(issue_params)
        TimelineEvent.create(:issue => @issue, :user => user, :message => "updated the issue")
        format.json { render json: @issue, serializer: IssueSerializer }
        format.html { redirect_to issue_path(@project.id, @issue.id), notice: "Issue was successfully updated." }
      else
        format.json { render json: @issue.errors, status: :unprocessable_entity }
          format.html do
            render 'edit', status: :unprocessable_entity
          end
      end
    end
  end

  def update_description
    @project = get_project
    @issue = get_issue
    user = get_user
    respond_to do |format|
      if @issue.update(issue_params)
        TimelineEvent.create(:issue => @issue, :user => current_user, :message => "updated the description")
        format.json { render json: @issue, serializer: IssueSerializer }
          format.html { redirect_to issue_path(@project.id, @issue.id), notice: "Issue was successfully updated." }
      else
        format.json { render json: @issue.errors, status: :unprocessable_entity }
        format.html { redirect_to issue_path(@project.id, @issue.id), notice: "Issue was unsuccessfully updated." }
      end
    end
  end

  def update_status
    @project = get_project
    @issue = get_issue
    @currentStatus = @issue.status
    user = get_user
    respond_to do |format|
      if @issue.update(issue_params)
        TimelineEvent.create(:issue => @issue, :user => user, :message => "changed the status from " + @currentStatus.capitalize() + " to " + @issue.status.capitalize())
        format.json { render json: @issue, serializer: IssueSerializer }
        format.html { redirect_to issue_path(@project.id, @issue.id), notice: "Issue was successfully updated." }
      else
        format.json { render json: @issue.errors, status: :unprocessable_entity }
        format.html { redirect_to issue_path(@project.id, @issue.id), notice: "Issue was unsuccessfully updated." }
      end
    end
  end

  def update_type
    @project = get_project
    @issue = get_issue
    @currentType = @issue.issue_type
    user = get_user
    respond_to do |format|
      if @issue.update(issue_params)
        TimelineEvent.create(:issue => @issue, :user => user, :message => "changed the type from " + @currentType.capitalize() + " to " + @issue.issue_type.capitalize())
        format.json { render json: @issue, serializer: IssueSerializer }
        format.html { redirect_to issue_path(@project.id, @issue.id), notice: "Issue was successfully updated." }
      else
        format.json { render json: @issue.errors, status: :unprocessable_entity }
        format.html { redirect_to issue_path(@project.id, @issue.id), notice: "Issue was unsuccessfully updated." }
      end
    end
  end

  def update_severity
    @project = get_project
    @issue = get_issue
    @currentSeverity = @issue.severity
    user = get_user
    respond_to do |format|
      if @issue.update(issue_params)
        TimelineEvent.create(:issue => @issue, :user => user, :message => "changed the severity from " + @currentSeverity.capitalize() + " to " + @issue.severity.capitalize())
        format.json { render json: @issue, serializer: IssueSerializer }
        format.html { redirect_to issue_path(@project.id, @issue.id), notice: "Issue was successfully updated." }
      else
        format.json { render json: @issue.errors, status: :unprocessable_entity }
        format.html { redirect_to issue_path(@project.id, @issue.id), notice: "Issue was unsuccessfully updated." }
      end
    end
  end

  def update_priority
    @project = get_project
    @issue = get_issue
    @currentPriority = @issue.priority
    user = get_user
    respond_to do |format|
      if @issue.update(issue_params)
        TimelineEvent.create(:issue => @issue, :user => user, :message => "changed the priority from " + @currentPriority.capitalize() + " to " + @issue.priority.capitalize())
        format.json { render json: @issue, serializer: IssueSerializer }
        format.html { redirect_to issue_path(@project.id, @issue.id), notice: "Issue was successfully updated." }
      else
        format.json { render json: @issue.errors, status: :unprocessable_entity }
        format.html { redirect_to issue_path(@project.id, @issue.id), notice: "Issue was unsuccessfully updated." }
      end
    end
  end

  def update_block
    @project = get_project
    @issue = get_issue
    @issue.update_attribute(:blocked, !@issue.blocked)
    if @issue.blocked?
      TimelineEvent.create(:issue => @issue, :user => current_user, :message => "blocked the issue")
    else
      TimelineEvent.create(:issue => @issue, :user => current_user, :message => "unblocked the issue")
    end
    redirect_to issue_path(@project.id, @issue.id)
  end

  def update_deadline
    @project = get_project
    @issue = get_issue
    @issue.update_attribute(:limitDate, params[:limitDate])
    user = get_user
    TimelineEvent.create(:issue => @issue, :user => user, :message => "changed the deadline")
    respond_to do |format|
      format.json { render json: @issue, serializer: IssueSerializer }
      format.html { redirect_to issue_path(@project.id, @issue.id), notice: "Issue was successfully updated." }
    end
  end

  def add_watcher
    @project = get_project
    @issue = get_issue
    @watcher = User.find(params[:user_id])
    WatchedIssue.create(:issue => @issue, :user => @watcher)
    redirect_to issue_path(@project.id, @issue.id)
  end

  def add_comment
    @project = get_project
    @issue = get_issue
    user = get_user
    Comment.create(:issue => @issue, :user => user, :text => params[:text])
    TimelineEvent.create(:issue => @issue, :user => user, :message => "wrote a new comment")
    respond_to do |format|
      format.json { render json: ActiveModel::Serializer::CollectionSerializer.new(@issue.comments, serializer: CommentSerializer) }
      format.html { redirect_to issue_path(@project.id, @issue.id), notice: "Comment was successfully uploaded." }
    end
  end

  def change_assigned
    @project = get_project
    @issue = get_issue
    @assigned = find_user
    @issue.assigned_to = @assigned
    @issue.save
    respond_to do |format|
      format.json { render json: @issue, serializer: IssueSerializer }
      format.html { redirect_to issue_path(@project.id, @issue.id), notice: "Assigned was successfully changed." }
    end
  end

  def attach_files
    @project = get_project
    @issue = get_issue
    @files = params[:files]
    @issue.files.attach(@files)
    TimelineEvent.create(:issue => @issue, :user => current_user, :message => "attached " + @files.length.to_s + " new file/s")
    redirect_to issue_path(@project.id, @issue.id)
  end

  # DELETE /issues/1 or /issues/1.json
  def destroy
    @project = get_project
    @issue = get_issue
    @issue.timeline_events.clear
    @issue.watched_issue.clear
    @issue.tags.clear
    @issue.comments.clear
    @issue.delete

    respond_to do |format|
      format.json { render json: ActiveModel::Serializer::CollectionSerializer.new(@project.issues, serializer: IssueBriefSerializer) }
      format.html { redirect_to project_issues_path(@project), notice: "Issue was successfully destroyed." }
    end
  end

  def delete_deadline
    @project = get_project
    @issue = get_issue
    if !@issue.limitDate.nil?
      @issue.update_attribute(:limitDate, nil)
      user = get_user
      TimelineEvent.create(:issue => @issue, :user => user, :message => "deleted the deadline")
    end 
    respond_to do |format|
      format.json { render json: @issue, serializer: IssueSerializer }
      format.html { redirect_to issue_path(@project.id, @issue.id), notice: "Issue was successfully updated." }
    end
  end

  def delete_watcher
    @project = get_project
    @issue = get_issue
    @watcher = User.find(params[:user_id])
    @watchedIssue = WatchedIssue.find_by(issue: @issue, user: @watcher)
    if @watchedIssue.delete
      redirect_to issue_path(@project.id, @issue.id)
    else
      raise "error"
    end
  end

  def delete_attachment
    @project = get_project
    @issue = get_issue
    @file = @issue.files.find(params[:file_id])
    @file.purge
    TimelineEvent.create(:issue => @issue, :user => current_user, :message => "deleted an attachment")
    redirect_to issue_path(@project.id, @issue.id)
  end
  

  private
    def get_project
      project_id = params[:project_id]
      if Project.where(id: project_id).present?
        Project.find(project_id)
      else
        raise ActionController::RoutingError.new('Not Found')
      end   
    end

    def get_issue
      issue_id = params[:id]
      project = get_project
      if project.issues.where(id: issue_id).present?
        Issue.find(issue_id)
      else
        raise ActionController::RoutingError.new('Not Found')
      end 
    end

    def get_user
      if request.format.html? 
        current_user
      else
        user = User.find_by_api_key(request.headers["HTTP_API_KEY"])
      end
    end

    def find_user
      user_id = params[:user_id]
      if User.where(id: user_id).present?
        User.find(user_id)
      else
        raise ActionController::RoutingError.new('Not Found')
      end
    end


    # Only allow a list of trusted parameters through.
    def issue_params
      if request.format.html? 
        params.require(:issue).permit(:subject, :description, :issue_type, :severity, :priority, :blocked, :status, :limitDate, :assigned_to_id, tag_ids: [], files: [])
      else 
        params.permit(:subject, :description, :issue_type, :severity, :priority, :blocked, :status, :limitDate, :assigned_to_id, tag_ids: [], files: [])
      end
    end    
end
