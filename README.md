# Ruby on Rails Todo Application

This project contains a simple todo application developed using Ruby on Rails. Users can add, edit, view, delete, and mark tasks as completed. Additionally, users can sign in with Google.

## Getting Started

To run the project on your local machine, follow these steps:

1. Clone this repository:

```bash
git clone https://github.com/onurkacmaz/rails-todo.git
```

```bash
cd rails-todo
```

2. Install the required gems:

```bash
bundle install
```

3. Create the database:

```bash
rails db:create
rails db:migrate
```

4. Start the server:

```bash
rails server
```

## Docker

```bash
docker-compose up
```

## Attention

### **DO NOT FORGET TO EDIT THE .env FILE**

## Rake Tasks

- `rake task:report::generate` - Generate a report for the tasks.