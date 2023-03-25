class MembershipController < ApplicationController

    def create
        @project = current_user.projects.build(project_params)
        respond_to do |format|
          if @project.save
            @membership = Membership.create(project: @project, user: current_user)
            format.html { redirect_to projects_url(), notice: "Project was successfully created." }
            format.json { render :show, status: :created, location: @project }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @project.errors, status: :unprocessable_entity }
          end
        end
      end
      
      
      private
      
      def membership_params
        params.require(:membership).permit(:project_id, :user_id)
      end
      
end
