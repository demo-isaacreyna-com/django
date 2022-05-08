# Django ORM

Download new project folder
Drop the storefront database

Create a new environment
```
pipenv install
````

Activate the virtual environment
```
pipenv shell
```

Migrate the schema to the new database
```
python manage.py migrate
```

Populate the database from the `seed.sql` file

Start the server
```bash
python manage.py runsrever
```
---
## Managers and Query sets

Use command+t to quickly find the function `say_hello()` in `playground/views.py`, and add a manager object (an interface to the database).
```python
from django.shortcuts import render
from django.http import HttpResponse
from store.models import Product

def say_hello(request):
    query_set = Product.objects.all()

    for product in query_set:
        print(product)

    return render(request, 'hello.html', { 'name': 'Isaac'})
```

When you navigate to `http://127.0.0.1:8000/playground/hello/` the terminal should output the following:
```
...
Product object (996)
Product object (997)
Product object (998)
Product object (999)
Product object (1000)
[02/May/2022 03:48:35] "GET /playground/hello/ HTTP/1.1" 200 22
```
---
## Retrieving Objects

Return a query set. When evaluated, gets all the objects in the table.
```
query_set = Product.objects.all()
```

Return a single object.
```
product = Product.objects.get(pk=1)
```

Catch exceptions with a try catch.
```python
from django.shortcuts import render
from django.core.exceptions import ObjectDoesNotExist
from store.models import Product

def say_hello(request):
    try:
        product = Product.objects.get(pk=0)
    except ObjectDoesNotExist:
        pass

    return render(request, 'hello.html', { 'product': 'some product' })
```

Check if the object exists
```python
from django.shortcuts import render
from django.core.exceptions import ObjectDoesNotExist
from store.models import Product

def say_hello(request):
    exists = Product.objects.filter(pk=0).exists()

    return render(request, 'hello.html', { 'productExists': exists })
```

Find all products that are greater than $20.
```python
queryset = Product.objects.filter(unit_price__gt=20)
```

Find all products where price range from $20 to $30, and render it.

`views.py`
```python
from django.shortcuts import render
from django.core.exceptions import ObjectDoesNotExist
from store.models import Product

def say_hello(request):
    queryset = Product.objects.filter(unit_price__range=(20, 30))

    return render(request, 'hello.html', { 'products': list(queryset)})
```

`hello.html`
```html
<h1>Products</h1>
<ul>
    {% for product in products %}
    <li>{{ product.title }}</li>
    {% endfor %}
</ul>
```

Find all the products in collection #1 who's id range is 1, 2, or 3
```python
# not tested
queryset = Product.objects.filter(collection__id__range=(1, 2, 3))
```

Find products that contain coffee in their title. Use `icontains` for a case insensitive search.
```python
queryset = Product.objects.filter(title__icontains='coffee')
```

Find products that were updated in 2021
```python
queryset = Product.objects.filter(last_update__year=2021)
```

Find products without a description
```python
queryset = Product.objects.filter(description__isnull=True)
```

Find more lookup types by searching for queryset api (Field lookups)

---
## Complex Lookups Using Q Objects

**Find Products with inventory less than 10 and price less than $20**

Example 1: Using mutiple keyword arguments
```python
queryset = Product.objects.filter(inventory__lt=10)
```

Example 2: Using chained filters
```python
queryset = Product.objects.filter(inventory__lt=10).filter(unit_price__lt=20)
```
**Using Q objects (query expression)**

Find products with inventory less than 10 or price less than $20
```python
from django.shortcuts import render
from django.db.models import Q
from store.models import Product

def say_hello(request):
    queryset = Product.objects.filter(
        Q(inventory__lt=10) | Q(unit_price__lt=20))

    return render(request, 'hello.html', { 'products': list(queryset)})
```

Find products with inventory less than 10 and unit price is **not** less than $20
```python
queryset = Product.objects.filter(
    Q(inventory__lt=10) & ~Q(unit_price__lt=20))
```
---
## Referencing Fields using F Objects
Hypothetical Example: Find products where inventory equals their unit price
```python
queryset = Product.objects.filter(inventory=F('unit_price'))
```
Using F objects you can reference a field in a related table.
Compare the inventory of the product with the id of its collection.
```python
from django.db.models import F
...
queryset = Product.objects.filter(inventory=F('collection_id'))
...
```
---
## Sorting
Get all Products and sort them by their title in ascending order
```python
queryset = Product.objects.order_by('title')
```

Sort by unit_price in asc order and then by title in desc order
```python
queryset = Product.objects.order_by('unit_price', '-title')
```

Reverse the direction of the sort. Sort unit_price in desc and title asc.
```python
queryset = Product.objects.order_by('unit_price', '-title').reverse()
```

Filter products to get products in collection 1, and sort them by their unit price
```python
queryset = Product.objects.filter(collection__id=1).order_by('unit_price')
```
See more options at djangoproject.com and navigate to QuerySet API -> Methods that return new QuerySets.

---
## Limiting Results
If products were displayed 5 per page, use array slicing syntax to return the second page of products (ids from 5 to 9)
```python
queryset = Product.objects.all()[5:10]
```
---
## Selecint Fields to Query
Instead of selecting all fields, just select id, title, and inner join the related field collection.title.
```python
# Returns dictionary
queryset = Product.objects.values('id', 'title', 'collection__title')

# Returns tuples
queryset = Product.objects.values_list('id', 'title', 'collection__title')
```
Select products that have been ordered, remove duplicates, and sort them by title
```python
from django.shortcuts import render
from store.models import Product, OrderItem

def say_hello(request):
    queryset = Product.objects.filter(
        id__in=OrderItem.objects.values('product_id').distinct()).order_by('title')

    return render(request, 'hello.html', { 'products': list(queryset)})
```

---
## Deferring Fields
The `only()` method can specify the fields we want to read from the database. This is different than the `values()` method, because it gets instances of the class instead of a dictionary object. Becareful using `only()`. It can result in an extra query to the database for each item.
```python
queryset = Product.objects.only('id', 'title')
```
The opposite for `only()` is `defer()`. Example: Return all fields except description.
```python
queryset = Product.objects.defer('description')
```

---
## Selecting Related Objects
When the other end of the relationship has one instance.
```python
queryset = Product.objects.select_related('collection').all()
```

Use prefetch_related when the other end of the relationship has many objects (ManyToMany).
```python
queryset = Product.objects.prefetch_related('promotions').all()
```
Combine these two calls. The order does not matter, meaning, `select_related` can be first and then `prefetch_related`.
```python
queryset = Product.objects.prefetch_related('promotions').select_related('collection').all()
```
Get the last 5 orders (desc order) with their customer and items including the product referenced in each order item

`views.py`
```python
from django.shortcuts import render
from store.models import Product, Order

def say_hello(request):
    
    queryset = Order.objects.select_related('customer').prefetch_related('orderitem_set__product').order_by('-placed_at')[:5]

    return render(request, 'hello.html', { 'orders': list(queryset)})
```
`hello.html`
```html
<ul>
    {% for order in orders %}
    <li>{{ order.id }} - {{ order.customer.first_name }}</li>
    {% endfor %}
</ul>
```
`Result`
```
408 - Olin
513 - Merna
711 - Rubi
327 - Karlotta
248 - Shandeigh
```

---
## Aggregating Objects
Compute summaries (max, average, etc) with `aggregate('field')` which will count all rows where that have the given field set.
```python
result = Product.objects.aggregate(Count('description'))
```

Rename the returned field
```python
result = Product.objects.aggregate(count=Count('description'))
```

Count number of products and find the min price
```python
result = Product.objects.aggregate(count=Count('id'), min_price=Min('unit_price'))
```

Filter products from a given collection and then calculate the summaries.
```python
result = Product.objects.filter(collection__id=1).aggregate(count=Count('id'), min_price=Min('unit_price'))
```

---
## Annotating Objects
Create a new attribute `is_new` to an object while querying them.
```python
from django.db.models import Value
...
queryset = Customer.objects.annotate(is_new=Value(True))
```
Create a new attribute `new_id` and set it to the same value as id field + 1.
```python
from django.db.models import F
...
queryset = Customer.objects.annotate(new_id=F('id') + 1)
```

---
## Calling Database Function
Create a new attribute `full_name`, and use the database function `CONACT` to combine `first_name` and `last_name`
```python
from django.shortcuts import render
from django.db.models import Value, F, Func
from store.models import Customer

def say_hello(request):
    
    queryset = Customer.objects.annotate(
        full_name=Func(F('first_name'), Value(' '), F('last_name'), function='CONCAT'))

    return render(request, 'hello.html', { 'customers': list(queryset) })
```

Other solution using django's Concat
```python
from django.shortcuts import render
from django.db.models import Value
from django.db.models.functions import Concat
from store.models import Customer

def say_hello(request):
    
    queryset = Customer.objects.annotate(
        full_name=Concat('first_name', Value(' '), 'last_name'))

    return render(request, 'hello.html', { 'customers': list(queryset) })\
```

---
## Grouping Data
Show the number of orders the customer has placed
```python
# There's a bug where we can't use order_set, so use order instead
queryset = Customer.objects.annotate(
    orders_count=Count('order')
)
```

---
## Working with Expression Wrappers

Do calculations with decimal and float types.
```python
from decimal import Decimal
from django.shortcuts import render
from django.db.models import ExpressionWrapper, F, DecimalField
from store.models import Product

def say_hello(request):
    discounted_price = ExpressionWrapper(F('unit_price') * 0.8, output_field=DecimalField())

    queryset = Product.objects.annotate(discounted_price=discounted_price)

    return render(request, 'hello.html', { 'products': list(queryset) })

```

---
## Querying Generic Relationships
In the tags apps, we used the ContentType framework to decouple this app from the store app. Let's use the tag app to load tags of a given product.

In the `django_content_type` database table we can see all the models we have in our application.

This table has three columns, `id`, `app_label`, and `model`. It displays rows where the `app_label` columns contains the name of app such ass `likes` and `store`, and the `model` column where it contains the name of the `models` for each app.

`Table: django_content_type`
```text
...
id  app_label   model
-------------------------
10  store       promotion
11  store       product
12	store	    orderitem	
13	store	    cartitem	
14	store	    address	
15	tags	    tag	
```

Let's take a look at the database table `tags_taggeditem` (reference table). To find the tags of a given product, we first have to find the `content_type_id` of the product model (11), and the `object_id` of the product.

`playground/views.py`
```python
from django.shortcuts import render
from django.contrib.contenttypes.models import ContentType
from store.models import Product
from tags.models import TaggedItem

def say_hello(request):
    # Find content type id for the product model
    content_type = ContentType.objects.get_for_model(Product)

    # Filter tagged item for product with id 1
    queryset = TaggedItem.objects \
        .select_related('tag') \
        .filter(
            content_type=content_type,
            object_id=1
    )

    return render(request, 'hello.html', { 'tags': list(queryset) })
```

---
## Custom Managers
To build a custom manager, we need to create a manager in the desired class, then move most of what we created in the previous example to the tags model.

`playground/views.py`
```python
from django.shortcuts import render
from django.contrib.contenttypes.models import ContentType
from store.models import Product
from tags.models import TaggedItem

def say_hello(request):
    TaggedItem.objects.get_tags_for(Product, 1)
    
    return render(request, 'hello.html', { 'tags': list(queryset) })
```

`tags/models.py`
```python
from django.db import models
from django.contrib.contenttypes.models import ContentType
from django.contrib.contenttypes.fields import GenericForeignKey

class TaggedItemManager(models.Manager):
    def get_tags_for(self, obj_type, obj_id):
        content_type = ContentType.objects.get_for_model(obj_type)

        return TaggedItem.objects \
            .select_related('tag') \
            .filter(
                content_type=content_type,
                object_id=obj_id
        )

class Tag(models.Model):
    label = models.CharField(max_length=255)

class TaggedItem(models.Model):
    objects = TaggedItemManager()
    tag = models.ForeignKey(Tag, on_delete=models.CASCADE)
    content_type = models.ForeignKey(ContentType, on_delete=models.CASCADE)
    object_id = models.PositiveBigIntegerField()
    content_object = GenericForeignKey()
```

---
## Understanding QuerySet Cache

```python
queryset = Product.objects.all()

# Reads from disk
list(queryset)

# Reads from memory
list(queryset)
```
Becareful on how your querysets are structured.
```python
queryset = Product.objects.all()
# Reads from disk
queryset[0]

# Reads from disk
list(queryset)
```

---
## Creating Objects
Insert a record in the database, that is equivalent to:

`INSERT INTO Collections (title, featured_product) VALUES ('Video Games', 1)`
```python
from django.shortcuts import render
from store.models import Collection, Product

def say_hello(request):
    collection = Collection()
    collection.title = 'Video Games'
    collection.featured_product = Product(pk=1)
    collection.save()

    return render(request, 'hello.html', { 'collectionId': collection.id })
```
These alternatives are shorter, but has no intellisense.
```python
    collection = Collection(title='Video Games', ...)
    # Or 
    Collection.objects.create(title='Video Games', ...)
```

---
## Updating Objects
Update an object that is equivalent to:

`UPDATE store_collection SET title = 'Games' featured_product_id = NULL WHERE store_collection.id = 11`
```python
from django.shortcuts import render
from store.models import Collection

def say_hello(request):
    collection = Collection(pk=11)
    collection.title = 'Games'
    collection.featured_product = None
    collection.save()

    return render(request, 'hello.html', { 'collectionId': collection.id })
```

Updating specific fields. Let's say we just want to set `featured_product` to `None`. If the following code is ran, it will set `collection.title` to an empty string!
```python
collection = Collection(pk=11)
collection.featured_product = None
collection.save()
```

At the cost of an extra call, first get the object and then perform the update.
```python
collection = Collection.objects.get(pk=11)
collection.featured_product = None
collection.save()
```
You can also use the following one-liner at a the cost of losing intellisense.
```python
Collection.objects.filter(pk=11).update(featured_product=None)
```

---
##  Deleting Objects
We can delete a single object or multiple objects in a single query set.
```python
# Delete single object
collection = Collection(pk=11)
collection.delete()

# Delete all objects where its id is greater than 5
Collection.objects.filter(id__gt=5).delete()
```

---
## Transactions
Making multiple changes to our database in an atomic way.

Example: Save order with items.
```python
    order = Order()
    order.customer_id = 1
    order.save()

    item = OrderItem()
    item.order = order
    item.product_id = 1
    item.quantity = 1
    item.unit_price = 10
    item.save()
```
If something happens in the time between saving an order and saving an item, we could end up with an order without any items. To prevents this we can use the `transaction.atomic()` annotation.

```python
from django.shortcuts import render
from django.db import transaction
from store.models import Order, OrderItem

@transaction.atomic()
def say_hello(request):
    order = Order()
    order.customer_id = 1
    order.save()

    item = OrderItem()
    item.order = order
    item.product_id = 1
    item.quantity = 1
    item.unit_price = 10
    item.save()

    return render(request, 'hello.html', { 'order': order.id })
```
In case we have code that shouldn't be part of the transaction we can do the following:
```python
from django.shortcuts import render
from django.db import transaction
from store.models import Order, OrderItem

def say_hello(request):
    #... code not part of transaction

    with transaction.atomic():
        order = Order()
        order.customer_id = 1
        order.save()

        item = OrderItem()
        item.order = order
        item.product_id = 1
        item.quantity = 1
        item.unit_price = 10
        item.save()

    return render(request, 'hello.html', { 'order': order.id })

```

---
## Executing Raw SQL Queries

Every manager comes with the raw method.
```python
from django.shortcuts import render
from store.models import Product

def say_hello(request):
    queryset = Product.objects.raw('SELECT id, title FROM store_product')

    return render(request, 'hello.html',
        { 
            'result': list(queryset)
        }
    )
```
Sometimes we want execute query that don't map to our data model object.
```python
from django.shortcuts import render
from store.models import Product
from django.db import connection

def say_hello(request):
    with connection.cursor() as cursor:
        cursor.execute('SELECT id, title FROM store_product')
        product = cursor.fetchone()
        products = cursor.fetchall()
    
    return render(request, 'hello.html',
        { 
            'product': product,
            'products': products
        }
    )
```
We can also use `callproc()`
```python
cursor.callproc('get_customers', [1, 2, 'a'])
```