# Slidepay Ruby Sdk

First version of the SlidePay Ruby SDK

## Building the Gem

```bash
$ gem build slidepay.gemspec
```

## The Basics

Requests can be made three ways:

1. Using the SlidePay request methods directly with the desired API url and relevant request JSON
2. [Coming Soon] Using an instance of the SlidePay::Client class to save an ApiResource, such as a payment, order, or item
3. [Coming Soon] Using an instance of a SlidePay::ApiResource class, such as SlidePay::ApiKey or SlidePay::Payment

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
```
or
```
SlidePay.get(path: "payment/#{payment_id}", api_key: "MY_TOKEN")
```

## Resources

SlidePay::ApiResources are classes that encapsulate RESTful API resources. API interaction relative to these resources is handled by the following descriptive methods:

- ```save ```
- ```destroy ```
- ```retrieve ```

The ```save``` method can handle both creation, via POST, and updating, via PUT, and determines which verb is appropriate by the ApiResource.is_new? method, which checks for the presence of an id in the resource.

## Testing

Test are in the spec directory, and can be run from the root of the repository:

```bash
$ rspec spec
```

Some tests will require that you have an active SlidePay account on the development server, and that you supply those credentials in an ```environment.rb``` file in the root of this repository.

Your populated environment.rb should look something like this:

```ruby
# Environment variables for testing. This Should NOT be included in VCS
ENV["email"]      = "email@example.com"
ENV["password"]   = "really_secure_password"
ENV["api_key"]    = "super-secret-api-key-that-you-never-share"
```

## Building

From the root of the repository, run the ```gem build``` command:

```bash
$ gem build slidepay.gemspec
```

## Note

The SlidePay::Client class and SlidePay::ApiResource classes are not fully tested or functional.

