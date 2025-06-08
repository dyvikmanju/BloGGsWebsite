#!/usr/bin/env bash
# build.sh

# 1. Install dependencies
pip install -r requirements.txt

# 2. Run migrations
python manage.py makemigrations
python manage.py migrate

# 3. Delete all users and create new superuser
python manage.py shell << 'EOF'
import os
from django.contrib.auth import get_user_model

print("\n===== Superuser Replacement =====\n")
User = get_user_model()

try:
    # Delete all users
    print("Deleting all existing users...")
    User.objects.all().delete()

    print("Creating new superuser...")
    User.objects.create_superuser(
        os.environ['DJANGO_SUPERUSER_USERNAME'],
        os.environ['DJANGO_SUPERUSER_EMAIL'],
        os.environ['DJANGO_SUPERUSER_PASSWORD']
    )
    print("SUCCESS: Superuser replaced.")
except Exception as e:
    print(f"ERROR: {str(e)}")
EOF


# 4. Collect static files (critical for production)
python manage.py collectstatic --noinput