from __future__ import unicode_literals

from django.db import models
from django.utils.encoding import python_2_unicode_compatible


@python_2_unicode_compatible
class Model(models.Model):

    class Meta:
        pass

    def __str__(self):
        pass

    @models.permalink
    def get_absolute_url(self):
        pass
