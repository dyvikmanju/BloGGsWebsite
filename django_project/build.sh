#!/usr/bin/env bash
# build.sh

# Install dependencies
pip install -r requirements.txt

# Run migrations
python manage.py migrate

# Create superuser (only if no users exist)
echo "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.create_superuser('$DJANGO_SUPERUSER_USERNAME', '$DJANGO_SUPERUSER_EMAIL', '$DJANGO_SUPERUSER_PASSWORD') if not User.objects.exists() else None" | python manage.py shell