# The Admin Site
Setting up the admin interface for managing our data. This is something that would take weeks to develop.
* Customizing the admin interface
* Adding computed columns
* Loading related objects
* Adding serach * filter
* Implementing custom actions
* Adding data validation

---
## Setting up the Admin Site
Every django project comes with an admin interface. First we need to create a new admin user:
```bash
python manage.py createsuperuser

Username: admin
Email address: your@email.com
Password: ****
Password (again): ****
Superuser created successfully.
```

To change the admin password run:
```bash
python manage.py changepassword admin
```
Navigate: `localhost:8000/admin`, and log in.

Let's change the header title from `Django administration` to `Storefront Admin`, and the subtitle from `Site administration` to `Admin`

`storefront/urls.py`
```python
from django.contrib import admin
from django.urls import path, include

admin.site.site_header = 'Storefront Admin'
admin.site.index_title = 'Admin'

urlpatterns = [
    path('admin/', admin.site.urls),
    path('playground/', include('playground.urls'))
]
```
---

## Registering Models
Show our models in the admin site.

`store/admin.py`
```python
from django.contrib import admin
from . import models

admin.site.register(models.Collection)
```

The Collections model will be loaded but displays as a representation of a model object
```text
COLLECTION
	Collection object (12)
	Collection object (11)
	Collection object (10)
	Collection object (9)
	Collection object (8)
	Collection object (7)
	Collection object (6)
	Collection object (5)
	Collection object (4)
	Collection object (3)
	Collection object (2)
```

Let's change this to show the title instead by overwritting the magic `__str__` method, and also order them by title.

`store/models.py`
```python
...
class Collection(models.Model):
    title = models.CharField(max_length=255)
    featured_product = models.ForeignKey('Product', on_delete=models.SET_NULL, null=True, related_name='+')

    def __str__(self) -> str:
        return self.title

    class Meta:
        ordering = ['title']
...
```
Do the same for Products

---
## Customizing the List Page
Add new columns, make them editable, change number of items, etc., for `Product` and `Customer` models.

`store/admin.py`
```python
from django.contrib import admin
from . import models

@admin.register(models.Product)
class ProductAdmin(admin.ModelAdmin):
    # Adds new columns
    list_display = ['title', 'unit_price']

    # Makes a column editable
    list_editable = ['unit_price']

    # Changes the list per page from 100 to 10
    list_per_page = 10

admin.site.register(models.Collection)

@admin.register(models.Customer)
class CustomerAdmin(admin.ModelAdmin):
    list_display = ['first_name', 'last_name', 'membership']
    list_editable = ['membership']
    ordering = ['first_name', 'last_name']
    list_per_page = 10
```

See the complete list of items to customize: https://docs.djangoproject.com/en/4.0/ref/contrib/admin/#modeladmin-options

---

## Adding Computed Columns
Add a computed column to the list of Products

`store/admin.py`
```python
from django.contrib import admin
from . import models

@admin.register(models.Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ['title', 'unit_price', 'inventory_status']
    list_editable = ['unit_price']
    list_per_page = 10

    @admin.display(ordering='inventory')
    def inventory_status(self, product):
        if product.inventory < 10:
            return 'Low'
        return 'OK'

admin.site.register(models.Collection)
```

---
## Selecting Related Objects

Add a new field to show the collection for each product, custom fields, etc.

`class Customers in store/admin.py`
```python
    def __str__(self):
        return f'{self.first_name} {self.last_name}'

    class Meta:
        ordering = ['first_name', 'last_name']
```
```python
from django.contrib import admin
from . import models

@admin.register(models.Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ['title', 'unit_price', 'inventory_status', 'collection_custom_title']
    list_editable = ['unit_price']
    list_per_page = 10
    list_select_related = ['collection']

    def collection_custom_title(self, product):
        return product.collection.title

    @admin.display(ordering='inventory')
    def inventory_status(self, product):
        if product.inventory < 10:
            return 'Low'
        return 'OK'

admin.site.register(models.Collection)

@admin.register(models.Customer)
class CustomerAdmin(admin.ModelAdmin):
    list_display = ['first_name', 'last_name', 'membership']
    list_editable = ['membership']
    ordering = ['first_name', 'last_name']
    list_per_page = 10

@admin.register(models.Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ['id', 'placed_at', 'customer']
```

---

## Overriding the Base QuerySet

```python
@admin.register(models.Collection)
class CollectionAdmin(admin.ModelAdmin):
    list_display = ['title']
    list_per_page = 10
```

Add `products_count`
```python
...
from django.db.models import Count
...
@admin.register(models.Collection)
class CollectionAdmin(admin.ModelAdmin):
    list_display = ['title', 'products_count']
    list_per_page = 10

    @admin.display(ordering='products_count')
    def products_count(self, collection):
        return collection.products_count
    
    def get_queryset(self, request):
        return super().get_queryset(request).annotate(products_count=Count('product'))
```

---