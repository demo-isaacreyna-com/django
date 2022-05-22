# Setting up dev environment

1. Clone the repo.
1. pipenv install
1. pipenv shell
1. Copy value from `pipenv --venv`
1. Press `Shift + Command + P` to bring up the command pallet.
1. Select `Python: Select Interpreter`
1. Select `Enter interpreter path...`
1. Paste the path value from `pipenv --env` and append: `/bin/python`
1. Export the following database connection variables:
    * POSTGRES_HOST
    * POSTGRES_DB
    * POSTGRES_USER
    * POSTGRES_PASSWORD
1. Run the server: `python manage.py runserver 8000`
1. Each time our models are changed run: `python manage.py makemigrations`
1. Run the migration against the database: python manage.py migrate`