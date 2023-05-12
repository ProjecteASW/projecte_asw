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
                project: { type: :string },
                issue: { type: :string },
                profile: { type: :string },
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
                project: { type: :string },
                issue: { type: :string },
                profile: { type: :string }
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
                project: { type: :string },
                issue: { type: :string },
                profile: { type: :string },
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
                project: { type: :string },
                issue: { type: :string },
                profile: { type: :string }
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

  path '/api/v1/pets/{id}/' do

    get 'Retrieves a pet' do
      tags 'Pets'
      produces 'application/json', 'application/xml'
      parameter name: :id, :in => :path, :type => :string

      response '200', 'name found' do
        schema type: :object,
          properties: {
            id: { type: :integer, },
            name: { type: :string },
            photo_url: { type: :string },
            status: { type: :string }
          },
          required: [ 'id', 'name', 'status' ]

        let(:id) { Pet.create(name: 'foo', status: 'bar', photo_url: 'http://example.com/avatar.jpg').id }
        run_test!
      end

      response '404', 'pet not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end




end