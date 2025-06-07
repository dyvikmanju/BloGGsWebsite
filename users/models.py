from django.db import models
from django.contrib.auth.models import User
from cloudinary.models import CloudinaryField

class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    image = CloudinaryField(
        'image',
        default='v1749283799/Screenshot_2025-06-05_094214_u0kkry',  # Only the public ID part
        blank=True,
        null=True
    )

    def __str__(self):
        return f'{self.user.username} Profile'

    def save(self, *args, **kwargs):
        # If no image is set, use default
        if not self.image:
            self.image = 'v1749283799/Screenshot_2025-06-05_094214_u0kkry'
        super().save(*args, **kwargs)

