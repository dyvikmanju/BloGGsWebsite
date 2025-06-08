#!/usr/bin/env bash
# build.sh

# 1. Install dependencies
pip install -r requirements.txt

# 2. Run migrations
python manage.py migrate

# 3. Create superuser (with debugging output)
python manage.py shell << 'EOF'
import os
from django.contrib.auth import get_user_model

print("\n===== Superuser Creation Debug =====\n")
User = get_user_model()

# Debug: Show received environment variables
print("Checking environment variables:")
print(f"USERNAME: {os.environ.get('DJANGO_SUPERUSER_USERNAME')}")
print(f"EMAIL: {os.environ.get('DJANGO_SUPERUSER_EMAIL')}")
print(f"PASSWORD SET: {bool(os.environ.get('DJANGO_SUPERUSER_PASSWORD'))}\n")

# Only create if no users exist
if not User.objects.exists():
    try:
        print("Attempting superuser creation...")
        User.objects.create_superuser(
            os.environ['DJANGO_SUPERUSER_USERNAME'],
            os.environ['DJANGO_SUPERUSER_EMAIL'],
            os.environ['DJANGO_SUPERUSER_PASSWORD']
        )
        print("SUCCESS: Superuser created!")
    except Exception as e:
        print(f"ERROR: {str(e)}")
else:
    print("Superuser already exists. Skipping creation.")
EOF

# 4. Collect static files (critical for production)
python manage.py collectstatic --noinput