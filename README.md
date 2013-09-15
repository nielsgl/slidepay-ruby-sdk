# Slidepay Ruby Sdk

First version of the SlidePay Ruby SDK

## Building the Gem

```bash
$ gem build slidepay.gemspec
```

## The Basics

Requests can be made three ways:

1. Using the SlidePay request methods directly with the desired API url and relevant request JSON
2. Using an instance of the SlidePay::Client class to save an ApiResource, such as a payment, order, or item
3. Using an instance of a SlidePay::ApiResource class, such as SlidePay::ApiKey or SlidePay::Payment

## Authentication

An authenticated request can be made if either an api_key or token are supplied to the request method.

Either of these fields can be set globally by assigning ```SlidePay.token``` or ```SlidePay.api_key```:

```ruby
SlidePay.token = "MY_TOKEN"
```

```ruby
SlidePay.api_key = "MY_API_KEY"
```

The global token can also be set using the global SlidePay authentication method:

```ruby
SlidePay.authenticate(email, password)
```

These fields can also be used on an instance or per-request level by either passing them into the SlidePay module request methods as a field in a hash, or by assigning instance variables on a SlidePay::Client.

```ruby
SlidePay.get(path: "payment/#{payment_id}", token: "MY_TOKEN")
SlidePay.get(path: "payment/#{payment_id}", api_key: "MY_TOKEN")
```

## Resources

SlidePay::ApiResources are classes that encapsulate RESTful API resources. API interaction relative to these resources is handled by the following descriptive methods:

- ```ruby save() ```
- ```ruby destroy ```
- ```ruby retrieve ```



### Authentication



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
