#!/usr/bin/env bash
# build.sh

# Exit immediately if any command fails
set -e

# 1. Install dependencies
pip install -r requirements.txt

# 2. Run migrations (with explicit app labels)
python manage.py makemigrations blog users  # specify your apps here
python manage.py migrate

# 3. Create superuser (improved error handling)
python manage.py shell << 'EOF'
import os
from django.contrib.auth import get_user_model
from django.db.utils import IntegrityError

print("\n===== Superuser Replacement =====")
User = get_user_model()

try:
    # Delete only if users exist to avoid noise
    if User.objects.exists():
        print("Deleting existing superusers...")
        User.objects.filter(is_superuser=True).delete()
    
    print("Creating new superuser...")
    User.objects.create_superuser(
        username=os.environ.get('DJANGO_SUPERUSER_USERNAME', 'admin'),
        email=os.environ.get('DJANGO_SUPERUSER_EMAIL', 'admin@example.com'),
        password=os.environ.get('DJANGO_SUPERUSER_PASSWORD', 'changeme123')
    )
    print("SUCCESS: Superuser created/replaced.")
except IntegrityError as e:
    print(f"NOTICE: Superuser already exists - {str(e)}")
except Exception as e:
    print(f"ERROR: {str(e)}")
    # Exit with error code if critical
    exit(1)
EOF

# 4. Collect static files (with verbose output)
python manage.py collectstatic --noinput --verbosity 2

# 5. Verify installation (optional but helpful)
python manage.py check --deploy