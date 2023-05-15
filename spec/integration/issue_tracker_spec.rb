require 'swagger_helper'

describe 'Issue Tracker API' do

  path '/profiles/{email_prefix}@{email_sufix}/' do

    get 'Obté la informació d\'un perfil' do
      tags 'Perfils'
      consumes 'application/json', 'application/xml'
      produces 'application/json'
      parameter name: :email_prefix, :in => :path, :type => :string
      parameter name: :email_sufix, :in => :path, :type => :string

      response '200', 'Operació exitosa' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          email: { type: :string },
          username: { type: :string },
          bio: { type: :string },
          profile_picture: { type: :string },
          timeline_events: {
            type: :array,
            items: {
              type: :object,
              properties: {
                project_id: { type: :integer },
                project: { type: :string },
                issue_id: { type: :integer },
                issue: { type: :string },
                message: { type: :string },
                data: { type: :string }
              }
            }
          },
          watched_issues: {
            type: :array,
            items: {
              type: :object,
              properties: {
                project_id: { type: :integer },
                project: { type: :string },
                issue_id: { type: :integer },
                issue: { type: :string }
              }
            }
          }
        }
        run_test!
      end

      response '404', 'Usuari no existent' do
        run_test!
      end
    end
  end

  path '/profiles/{email_prefix}@{email_sufix}/' do

    put 'Actualitza la informació d\'un perfil' do
      tags 'Perfils'
      consumes 'multipart/form-data'
      produces 'application/json'
      parameter name: :email_prefix, :in => :path, :type => :string
      parameter name: :email_sufix, :in => :path, :type => :string
      parameter name: :'', in: :formData, schema: {
        type: :object,
        properties: {
          username: { type: :string },
          bio: { type: :string },
          avatar: { type: :file },
        }
      }
      

      response '200', 'Operació exitosa' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          email: { type: :string },
          username: { type: :string },
          bio: { type: :string },
          profile_picture: { type: :string },
          timeline_events: {
            type: :array,
            items: {
              type: :object,
              properties: {
                project_id: { type: :integer },
                project: { type: :string },
                issue_id: { type: :integer },
                issue: { type: :string },
                message: { type: :string },
                data: { type: :string }
              }
            }
          },
          watched_issues: {
            type: :array,
            items: {
              type: :object,
              properties: {
                project_id: { type: :integer },
                project: { type: :string },
                issue_id: { type: :integer },
                issue: { type: :string }
              }
            }
          }
        }
        run_test!
      end

      response '404', 'Usuari no existent' do
        run_test!
      end
    end
  end

  path '/projects/{project_id}/issues/{issue_id}/' do

    get 'Obté la informació d\'una Issue' do
      tags 'Issues'
      consumes 'application/json', 'application/xml'
      produces 'application/json'
      security [ApiKeyAuth: []]
      parameter name: :project_id, :in => :path, :type => :integer
      parameter name: :issue_id, :in => :path, :type => :integer

      response '200', 'Operació exitosa' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          subject: { type: :string },
          description: { type: :string },
          status: { type: :string },
          created_by_user_id: {type: :integer},
          created_at: { type: :string },
          issue_type: { type: :string },
          severity: { type: :string },
          priority: { type: :string },
          limitDate: { type: :string },
          blocked: { type: :boolean },
          assigned_profile: { type: :integer },
          timeline_events: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string },
                message: { type: :string },
                date: { type: :string }
              }
            }
          },
          watched_issues: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string },
              }
            }
          }
        }
        run_test!
      end

      response '404', 'Projecte o Issue no existent' do
        run_test!
      end
    end
  end




end