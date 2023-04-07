# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Create some users
user1 = User.create!(
  email: 'user1@example.com',
  password: 'password',
  username: 'user1',
  bio: 'I am user 1'
)

user2 = User.create!(
  email: 'user2@example.com',
  password: 'password',
  username: 'user2',
  bio: 'I am user 2'
)

# Create some projects
project1 = Project.create!(
  name: 'Project 1',
  description: 'This is project 1',
  user: user1
)

project2 = Project.create!(
  name: 'Project 2',
  description: 'This is project 2',
  user: user2
)

# Add users to projects
Membership.create!(
  user: user1,
  project: project1
)

Membership.create!(
  user: user2,
  project: project2
)

# Create some issues
issue1 = Issue.create!(
  subject: 'Issue 1',
  description: 'This is issue 1',
  issue_type: 1,
  severity: 1,
  priority: 1,
  status: 1,
  limitDate: '2023-04-15',
  blocked: false,
  project: project1,
  user: user1
)

issue2 = Issue.create!(
  subject: 'Issue 2',
  description: 'This is issue 2',
  issue_type: 2,
  severity: 2,
  priority: 2,
  status: 2,
  limitDate: '2023-04-30',
  blocked: true,
  project: project2,
  user: user2
)

# Add tags to issues
Tag.create!(
  name: 'Tag 1',
  issue: issue1
)

Tag.create!(
  name: 'Tag 2',
  issue: issue2
)

# Create some comments
Comment.create!(
  text: 'Comment 1',
  user: user1,
  issue: issue1
)

Comment.create!(
  text: 'Comment 2',
  user: user2,
  issue: issue2
)

# Create some watched issues
WatchedIssue.create!(
  user: user1,
  issue: issue1
)

WatchedIssue.create!(
  user: user2,
  issue: issue2
)

# Create some timeline events
TimelineEvent.create!(
  message: 'Timeline event 1',
  user: user1,
  issue: issue1
)

TimelineEvent.create!(
  message: 'Timeline event 2',
  user: user2,
  issue: issue2
)