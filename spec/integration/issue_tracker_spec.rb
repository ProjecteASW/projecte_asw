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
      security [ApiKeyAuth: []]
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

  path '/projects/' do

    get 'Obté tots els projectes' do
      tags 'Projects'
      consumes 'application/json', 'application/xml'
      produces 'application/json'

      response '200', 'Operació exitosa' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          name: { type: :string }
        }
        run_test!
      end

      response '404', 'Usuari no existent' do
        run_test!
      end
    end
  end

  path '/projects/{project_id}/issues/' do

    get 'Obté totes les Issues d\'un Projecte' do
      tags 'Issues'
      consumes 'application/json', 'application/xml'
      produces 'application/json'
      parameter name: :project_id, :in => :path, :type => :integer
      
      parameter name: :search, in: :query, required: false, type: :string
      parameter name: :status, in: :query, required: false, schema: {
        type: :string,
        enum: ['open', 'in_progress', 'testing', 'reopened', 'resolved']
      }
      parameter name: :issue_type, in: :query, required: false, schema: {
        type: :string,
        enum: ['bug', 'question', 'enhancement']
      }
      parameter name: :severity, in: :query, required: false, schema: {
        type: :string,
        enum: ['wishlist', 'minor', 'norm', 'important', 'critical']
      }
      parameter name: :priority, in: :query, required: false, schema: {
        type: :string,
        enum: ['low', 'normal', 'high']
      }
      parameter name: :sort_by, in: :query, required: false, schema: {
        type: :string,
        enum: ["issue_type", "status", "severity", "priority", "subject"]
      }
      

      response '200', 'Operació exitosa' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          subject: { type: :string },
          status: { type: :string },
          creation_date: { type: :string },
          issue_type: { type: :string },
          severity: { type: :string },
          priority: { type: :string },
          blocked: { type: :boolean },
          assigned_profile_id: { type: :integer },
          assigned_profile_username: { type: :string }
        }
        run_test!
      end

      response '404', 'Usuari no existent' do
        run_test!
      end
    end
  end

  path '/projects/{project_id}/issues/' do

    post 'Crea una nova Issue' do
      tags 'Issues'
      consumes 'application/json', 'multipart/form-data'
      produces 'application/json'
      security [ApiKeyAuth: []]
      parameter name: :project_id, :in => :path, :type => :integer
      parameter name: :issue, :in => :body, schema: {
        type: :object,
        properties: {
          subject: { type: :string },
          description: { type: :string },
          issue_type: { 
              type: :string,
              enum: ['bug', 'question', 'enhancement'],
              default: 'bug'
          },
          severity: { 
              type: :string,
              enum: ['wishlist', 'minor', 'norm', 'important', 'critical'],
              default: 'wishlist'
          },
          priority: { 
              type: :string,
              enum: ['low', 'normal', 'high'],
              default: 'low'
          },
          blocked: { 
              type: :boolean,
              default: 'false'
          },
          limitDate: { type: :string, format: :date }
        },
        required: [:subject, :issue_type, :severity, :priority, :blocked]
      }


      response '201', 'Issue creada' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          subject: { type: :string },
          description: { type: :string },
          status: { type: :string },
          created_by_user_id: {type: :integer},
          created_by_user_username: {type: :string},
          creation_date: { type: :string },
          issue_type: { type: :string },
          severity: { type: :string },
          priority: { type: :string },
          limitDate: { type: :string },
          blocked: { type: :boolean },
          assigned_profile_id: { type: :integer },
          assigned_profile_username: { type: :string },
          watchers: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string }
              }
            }
          },
          attachments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                path: { type: :string }
              }
            }
          },
          activities: {
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
          comments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string },
                text: { type: :string },
                date: { type: :string },
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

  path '/projects/{project_id}/issues/bulk_create/' do

    post 'Crea un conjunt de noves Issues' do
      tags 'Issues'
      consumes 'application/json', 'multipart/form-data'
      produces 'application/json'
      security [ApiKeyAuth: []]
      parameter name: :project_id, :in => :path, :type => :integer
      parameter name: :'', :in => :body, schema: {
        type: :object,
        properties: {
          issue_names: { :type => :string }
        }
      }
      


      response '201', 'Issues creades' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          subject: { type: :string },
          status: { type: :string },
          creation_date: { type: :string },
          issue_type: { type: :string },
          severity: { type: :string },
          priority: { type: :string },
          blocked: { type: :boolean },
          assigned_profile_id: { type: :integer },
          assigned_profile_username: { type: :string }
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
          created_by_user_username: {type: :string},
          creation_date: { type: :string },
          issue_type: { type: :string },
          severity: { type: :string },
          priority: { type: :string },
          limitDate: { type: :string },
          blocked: { type: :boolean },
          assigned_profile_id: { type: :integer },
          assigned_profile_username: { type: :string },
          watchers: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string }
              }
            }
          },
          attachments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                path: { type: :string }
              }
            }
          },
          activities: {
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
          comments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string },
                text: { type: :string },
                date: { type: :string },
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


    put 'Edita una Issue' do
      tags 'Issues'
      consumes 'application/json', 'multipart/form-data'
      produces 'application/json'
      security [ApiKeyAuth: []]
      parameter name: :project_id, :in => :path, :type => :integer
      parameter name: :issue_id, :in => :path, :type => :integer
      parameter name: :issue, :in => :body, schema: {
        type: :object,
        properties: {
          description: { type: :string },
          status: { 
              type: :string,
              enum: ['open', 'in_progress', 'testing', 'reopened', 'resolved'],
              default: 'open'
          },
          issue_type: { 
              type: :string,
              enum: ['bug', 'question', 'enhancement'],
              default: 'bug'
          },
          severity: { 
              type: :string,
              enum: ['wishlist', 'minor', 'norm', 'important', 'critical'],
              default: 'wishlist'
          },
          priority: { 
              type: :string,
              enum: ['low', 'normal', 'high'],
              default: 'low'
          },
          blocked: { 
              type: :boolean,
              default: 'false'
          },
          limitDate: { type: :string, format: :date }
        },
        required: [:status, :issue_type, :severity, :priority, :blocked]
      }


      response '201', 'Issue creada' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          subject: { type: :string },
          description: { type: :string },
          status: { type: :string },
          created_by_user_id: {type: :integer},
          created_by_user_username: {type: :string},
          creation_date: { type: :string },
          issue_type: { type: :string },
          severity: { type: :string },
          priority: { type: :string },
          limitDate: { type: :string },
          blocked: { type: :boolean },
          assigned_profile_id: { type: :integer },
          assigned_profile_username: { type: :string },
          watchers: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string }
              }
            }
          },
          attachments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                path: { type: :string }
              }
            }
          },
          activities: {
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
          comments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string },
                text: { type: :string },
                date: { type: :string },
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


    delete 'Elimina una Issue' do
      tags 'Issues'
      consumes 'application/json', 'multipart/form-data'
      produces 'application/json'
      security [ApiKeyAuth: []]
      parameter name: :project_id, :in => :path, :type => :integer
      parameter name: :issue_id, :in => :path, :type => :integer
      
      response '200', 'Issue eliminada' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          subject: { type: :string },
          status: { type: :string },
          creation_date: { type: :string },
          issue_type: { type: :string },
          severity: { type: :string },
          priority: { type: :string },
          blocked: { type: :boolean },
          assigned_profile_id: { type: :integer },
          assigned_profile_username: { type: :string }
        }
        run_test!
      end

      response '404', 'Issue no existent' do
        run_test!
      end
    end
  end

  path '/projects/{project_id}/issues/{issue_id}/description/' do
    put 'Edita la descripció d\'una Issue' do
      tags 'Issues'
      consumes 'application/json', 'multipart/form-data'
      produces 'application/json'
      security [ApiKeyAuth: []]
      parameter name: :project_id, :in => :path, :type => :integer
      parameter name: :issue_id, :in => :path, :type => :integer
      parameter name: :issue, :in => :body, schema: {
        type: :object,
        properties: {
          description: { type: :string }
        }
      }


      response '200', 'Issue creada' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          subject: { type: :string },
          description: { type: :string },
          status: { type: :string },
          created_by_user_id: {type: :integer},
          created_by_user_username: {type: :string},
          creation_date: { type: :string },
          issue_type: { type: :string },
          severity: { type: :string },
          priority: { type: :string },
          limitDate: { type: :string },
          blocked: { type: :boolean },
          assigned_profile_id: { type: :integer },
          assigned_profile_username: { type: :string },
          watchers: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string }
              }
            }
          },
          attachments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                path: { type: :string }
              }
            }
          },
          activities: {
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
          comments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string },
                text: { type: :string },
                date: { type: :string },
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


  path '/projects/{project_id}/issues/{issue_id}/status/' do
    put 'Edita el Status d\'una Issue' do
      tags 'Issues'
      consumes 'application/json', 'multipart/form-data'
      produces 'application/json'
      security [ApiKeyAuth: []]
      parameter name: :project_id, :in => :path, :type => :integer
      parameter name: :issue_id, :in => :path, :type => :integer
      parameter name: :issue, :in => :body, schema: {
        type: :object,
        properties: {
          status: { 
              type: :string,
              enum: ['open', 'in_progress', 'testing', 'reopened', 'resolved'],
              default: 'open'
          }
        },
        required: [:status]
      }


      response '200', 'Issue creada' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          subject: { type: :string },
          description: { type: :string },
          status: { type: :string },
          created_by_user_id: {type: :integer},
          created_by_user_username: {type: :string},
          creation_date: { type: :string },
          issue_type: { type: :string },
          severity: { type: :string },
          priority: { type: :string },
          limitDate: { type: :string },
          blocked: { type: :boolean },
          assigned_profile_id: { type: :integer },
          assigned_profile_username: { type: :string },
          watchers: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string }
              }
            }
          },
          attachments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                path: { type: :string }
              }
            }
          },
          activities: {
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
          comments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string },
                text: { type: :string },
                date: { type: :string },
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


  path '/projects/{project_id}/issues/{issue_id}/type/' do
    put 'Edita el tipus d\'una Issue' do
      tags 'Issues'
      consumes 'application/json', 'multipart/form-data'
      produces 'application/json'
      security [ApiKeyAuth: []]
      parameter name: :project_id, :in => :path, :type => :integer
      parameter name: :issue_id, :in => :path, :type => :integer
      parameter name: :issue, :in => :body, schema: {
        type: :object,
        properties: {
          issue_type: { 
            type: :string,
            enum: ['bug', 'question', 'enhancement'],
            default: 'bug'
          }
        },
        required: [:issue_type]
      }


      response '200', 'Issue creada' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          subject: { type: :string },
          description: { type: :string },
          status: { type: :string },
          created_by_user_id: {type: :integer},
          created_by_user_username: {type: :string},
          creation_date: { type: :string },
          issue_type: { type: :string },
          severity: { type: :string },
          priority: { type: :string },
          limitDate: { type: :string },
          blocked: { type: :boolean },
          assigned_profile_id: { type: :integer },
          assigned_profile_username: { type: :string },
          watchers: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string }
              }
            }
          },
          attachments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                path: { type: :string }
              }
            }
          },
          activities: {
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
          comments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string },
                text: { type: :string },
                date: { type: :string },
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


  path '/projects/{project_id}/issues/{issue_id}/severity/' do
    put 'Edita la severitat d\'una Issue' do
      tags 'Issues'
      consumes 'application/json', 'multipart/form-data'
      produces 'application/json'
      security [ApiKeyAuth: []]
      parameter name: :project_id, :in => :path, :type => :integer
      parameter name: :issue_id, :in => :path, :type => :integer
      parameter name: :issue, :in => :body, schema: {
        type: :object,
        properties: {
          severity: { 
              type: :string,
              enum: ['wishlist', 'minor', 'norm', 'important', 'critical'],
              default: 'wishlist'
          }
        },
        required: [:severity]
      }


      response '200', 'Issue creada' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          subject: { type: :string },
          description: { type: :string },
          status: { type: :string },
          created_by_user_id: {type: :integer},
          created_by_user_username: {type: :string},
          creation_date: { type: :string },
          issue_type: { type: :string },
          severity: { type: :string },
          priority: { type: :string },
          limitDate: { type: :string },
          blocked: { type: :boolean },
          assigned_profile_id: { type: :integer },
          assigned_profile_username: { type: :string },
          watchers: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string }
              }
            }
          },
          attachments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                path: { type: :string }
              }
            }
          },
          activities: {
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
          comments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string },
                text: { type: :string },
                date: { type: :string },
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


  path '/projects/{project_id}/issues/{issue_id}/priority/' do
    put 'Edita la prioritat d\'una Issue' do
      tags 'Issues'
      consumes 'application/json', 'multipart/form-data'
      produces 'application/json'
      security [ApiKeyAuth: []]
      parameter name: :project_id, :in => :path, :type => :integer
      parameter name: :issue_id, :in => :path, :type => :integer
      parameter name: :issue, :in => :body, schema: {
        type: :object,
        properties: {
          priority: { 
              type: :string,
              enum: ['low', 'normal', 'high'],
              default: 'low'
          }
        },
        required: [:priority]
      }


      response '200', 'Issue creada' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          subject: { type: :string },
          description: { type: :string },
          status: { type: :string },
          created_by_user_id: {type: :integer},
          created_by_user_username: {type: :string},
          creation_date: { type: :string },
          issue_type: { type: :string },
          severity: { type: :string },
          priority: { type: :string },
          limitDate: { type: :string },
          blocked: { type: :boolean },
          assigned_profile_id: { type: :integer },
          assigned_profile_username: { type: :string },
          watchers: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string }
              }
            }
          },
          attachments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                path: { type: :string }
              }
            }
          },
          activities: {
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
          comments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string },
                text: { type: :string },
                date: { type: :string },
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


  path '/projects/{project_id}/issues/{issue_id}/date/' do
    put 'Edita la deadline d\'una Issue' do
      tags 'Issues'
      consumes 'application/json', 'multipart/form-data'
      produces 'application/json'
      security [ApiKeyAuth: []]
      parameter name: :project_id, :in => :path, :type => :integer
      parameter name: :issue_id, :in => :path, :type => :integer
      parameter name: :issue, :in => :body, schema: {
        type: :object,
        properties: {
          limitDate: { type: :string, format: :date }
        },
        required: [:limitDate]
      }


      response '200', 'Issue creada' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          subject: { type: :string },
          description: { type: :string },
          status: { type: :string },
          created_by_user_id: {type: :integer},
          created_by_user_username: {type: :string},
          creation_date: { type: :string },
          issue_type: { type: :string },
          severity: { type: :string },
          priority: { type: :string },
          limitDate: { type: :string },
          blocked: { type: :boolean },
          assigned_profile_id: { type: :integer },
          assigned_profile_username: { type: :string },
          watchers: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string }
              }
            }
          },
          attachments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                path: { type: :string }
              }
            }
          },
          activities: {
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
          comments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string },
                text: { type: :string },
                date: { type: :string },
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

    delete 'Elimina la deadline d\'una Issue' do
      tags 'Issues'
      consumes 'application/json', 'multipart/form-data'
      produces 'application/json'
      security [ApiKeyAuth: []]
      parameter name: :project_id, :in => :path, :type => :integer
      parameter name: :issue_id, :in => :path, :type => :integer


      response '200', 'Issue creada' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          subject: { type: :string },
          description: { type: :string },
          status: { type: :string },
          created_by_user_id: {type: :integer},
          created_by_user_username: {type: :string},
          creation_date: { type: :string },
          issue_type: { type: :string },
          severity: { type: :string },
          priority: { type: :string },
          limitDate: { type: :string },
          blocked: { type: :boolean },
          assigned_profile_id: { type: :integer },
          assigned_profile_username: { type: :string },
          watchers: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string }
              }
            }
          },
          attachments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                path: { type: :string }
              }
            }
          },
          activities: {
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
          comments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string },
                text: { type: :string },
                date: { type: :string },
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

  path '/projects/{project_id}/issues/{issue_id}/assigned/' do
    put 'Canvia el perfil assignat a la Issue' do
      tags 'Issues'
      consumes 'application/json', 'multipart/form-data'
      produces 'application/json'
      security [ApiKeyAuth: []]
      parameter name: :project_id, :in => :path, :type => :integer
      parameter name: :issue_id, :in => :path, :type => :integer
      parameter name: :issue, :in => :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :string }
        },
        required: [:user_id]
      }


      response '200', 'Issue creada' do
        schema type: :object,
        properties: {
          id: { type: :integer },
          subject: { type: :string },
          description: { type: :string },
          status: { type: :string },
          created_by_user_id: {type: :integer},
          created_by_user_username: {type: :string},
          creation_date: { type: :string },
          issue_type: { type: :string },
          severity: { type: :string },
          priority: { type: :string },
          limitDate: { type: :string },
          blocked: { type: :boolean },
          assigned_profile_id: { type: :integer },
          assigned_profile_username: { type: :string },
          watchers: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string }
              }
            }
          },
          attachments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                name: { type: :string },
                path: { type: :string }
              }
            }
          },
          activities: {
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
          comments: {
            type: :array,
            items: {
              type: :object,
              properties: {
                profile_id: { type: :integer },
                profile: { type: :string },
                text: { type: :string },
                date: { type: :string },
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


  path '/projects/{project_id}/issues/{issue_id}/comments/' do
    post 'Publica un nou comentari a la Issue' do
      tags 'Issues'
      consumes 'application/json', 'multipart/form-data'
      produces 'application/json'
      security [ApiKeyAuth: []]
      parameter name: :project_id, :in => :path, :type => :integer
      parameter name: :issue_id, :in => :path, :type => :integer
      parameter name: :issue, :in => :body, schema: {
        type: :object,
        properties: {
          text: { type: :string }
        },
        required: [:text]
      }


      response '200', 'Issue creada' do
        schema type: :array,
        items: {
          type: :object,
          properties: {
            profile_id: { type: :integer },
            profile: { type: :string },
            text: { type: :string },
            date: { type: :string }
          }
        }
        run_test!
      end

      response '404', 'Usuari no existent' do
        run_test!
      end
    end
  end

end