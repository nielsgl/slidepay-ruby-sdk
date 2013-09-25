

# Slidepay Ruby Sdk

[![Gem Version](https://badge.fury.io/rb/slidepay.png)](http://badge.fury.io/rb/slidepay) [![Build Status](https://travis-ci.org/SlidePay/slidepay-ruby-sdk.png)](https://travis-ci.org/SlidePay/slidepay-ruby-sdk) [![Code Climate](https://codeclimate.com/repos/5236cb7013d6371e46004010/badges/f963bebb1565c5419c78/gpa.png)](https://codeclimate.com/repos/5236cb7013d6371e46004010/feed)

First version of the SlidePay Ruby SDK

## Dependencies

We depend on these fantastic libraries:

- [rest-client](https://github.com/rest-client/rest-client)
- [multi_json](https://github.com/intridea/multi_json)
- [json](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/json/rdoc/JSON.html)

## Building the Gem

From the root of the repository, run the ```gem build``` command:

```bash
$ gem build slidepay.gemspec
```

## How Does SlidePay's API Work?

Check out our [main documentation](https://getcube.atlassian.net/wiki/display/CDP/Getting+Started) for detailed information about how the API works, as well as information about functionality not yet wrapped by this library.

## The Ruby SDK Basics

Requests can be made three ways:

1. Using the SlidePay request methods directly with the desired API url and relevant request JSON
2. [Coming Soon] Using an instance of the SlidePay::Client class to save an ApiResource, such as a payment, order, or item
3. Using an instance of a SlidePay::ApiResource class, such as SlidePay::ApiKey or SlidePay::Payment

## Authentication

A request to SlidePay is considered authenticated if either an api_key or token are present in the request. Information about how those are sent, and how they are obtained, can be found on [the authentication page of the api documentation](https://getcube.atlassian.net/wiki/display/CDP/Making+your+first+API+call%3A+authentication).

Both the api_key and token can be set in a global, instance, and request context. The order of precedence goes from most to least specific, and tokens are of greater significance than api_keys. This means that an api_key provided to an instance of an ApiResource would be used over a global token, but would be ignored in the face of a token set on that same object, and would yield to either provided to a single request method.

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

You can retrieve a token for use in any context with the retrieve_token method, which is similar to SlidePay.authenticate except that it returns the token string and does not set a global token value.

```ruby
SlidePay.authenticate(email, password)
```

These fields can also be used on an instance or per-request level by either passing them into the SlidePay module request methods as a field in a hash, or by assigning instance variables on a SlidePay::Client.

```ruby
SlidePay.get(path: "payment/#{payment_id}", token: "MY_TOKEN")
```
or
```ruby
SlidePay.get(path: "payment/#{payment_id}", api_key: "MY_API_KEY")
```

## Resources

SlidePay::ApiResources are classes that encapsulate RESTful API resources. API interaction relative to these resources is handled by the following descriptive methods:

- ```save ```
- ```destroy ```
- ```retrieve ```

The ```save``` method can handle both creation, via POST, and updating, via PUT, and determines which verb is appropriate by the ```ApiResource.is_new?``` method, which checks for the presence of an id in the resource.

## Payments

Payments are much like resources, except they cannot be updated or destroyed once created. Two more relevant instance methods for interacting with payments are provided.

To process a payment, supply a JSON representation of a valid [simple_payment](https://getcube.atlassian.net/wiki/display/CDP/Processing+a+Simple+Payment) object on instantiation, and then call that instance's ```process``` method:

```ruby
p = SlidePay::Payment.new(simple_payment_json)
p.process()
```

To refund a payment, call an existing payment's ```refund``` method, or POST to the ```payment/refund/:payment_id``` API path:

```ruby
# Refund from an object
p.refund()

# Refund using SlidePay.post
SlidePay.post(path: 'payment/refund/#{payment_id}')
```

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

## Notes

The SlidePay::Client class is largely untested and likely non-functional.

Though this document rarely mentions authentication in most examples following the section above dedicated to it, an api_key or token, and an endpoint, may be supplied to any object or module that can perform an API request. This flexibility allows for interacting with a single instance of a single ApiResource class without having to use the SlidePay module methods directly, or having to use an instance of the SlidePay::Client class. It also accommodates those developers who may wish to authenticate many SlidePay accounts within a single thread, such as inside a request context of a Rails application, or in a scheduled task, without having to repeatedly set the SlidePay.token or SlidePay.api_key global values.

## License

The MIT License (MIT)

Copyright (c) 2013 SlidePay