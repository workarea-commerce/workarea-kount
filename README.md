# Workarea Kount

Kount plugin for the Workarea platform.

## Kount Response Codes

Kount's Risk Inquiry Services will return one of three values.

Approved - the order is not suspected as fraud

Decline - the order is fraud

Hold for manager review - the order is suspected fraud

## Kount Order Flow

### In Checkout

The Kount plugin sends the credit card and paypal orders to Kount before payment
is captured. Based on the response from Kount different actions will be taken.

#### Approved - The order is not fraud

The order is placed.

#### Decline - The order is fraud

An error is shown to the customer and redirected back to the payment step.

#### Hold for manager review - the order is suspected fraud

The credit card is tokenized and inventory is captured but the payment is not
authorized/purchased. The customer is shown the order confirmation as if the
order is placed. A Kount admin user needs to use approve or decline the order
via the Kount admin.

The Kount Event Notificaion System (ENS) will post the data back to Workarea.

If the admin declines the order in Kount, the order is canceled and the customer
recieves a cancelation email.

If the admin approves the order, the payment is attemped to be captured. If the
payment captures successfully the order is placed.  If the payment fails
authorization/purchase, the order is canceled and the customer recives a
cancelation email.

## Configuration

Add values for `merchant_id`, `version`, `key`, and `ksalt` to your application secrets

```yaml
  kount:
    merchant_id:
    version:
    key:
    ksalt:
    ens_username: username for basic auth for ENS
    ens_password: password for basic auth for ENS
    kount_site: <site name for ENS>
```

### Event Notification System Configuration

The Kount ENS requires configuration in Workarea to match configuration in Kount.
If the ENS is not configured properly, Kount review decisions will not be
received by Workarea.

Workarea uses basic auth credentials `ens_username:ens_password` to authenticate
requests from the Kount ENS. If your application is behind basic_auth (e.g. in
staging or QA) you should configure these credentials to match your basic auth
credentials for the environment. If your application is not behind basic auth
these credentials can be anything you want, as long as they are secure.

#### Kount Site

The `kount_site` configuration is used by kount ENS to determine which endpoint
events should be sent to. If no `kount_site` is provided the DEFAULT site will
be used. `kount_site` can be used to configure different ENS endpoints for
testing inQA and Staging, or for multi-site implementations.

#### Configure ENS in Kount

In the Kount admin navigate to: Fraud Control -> Websites -> Add Website

The ENS Api URL should look like `https://ENS_USERNAME:ENS_PASSWORD@WEBSITE_DOMAIN/kount_orders`

Example: `https://kount:aksjei8243d8@www.example.com/kount_orders`

## Workarea Platform Documentation

See [http://developer.workarea.com](http://developer.workarea.com) for Workarea
platform documentation.

## Copyright & Licensing

Copyright WebLinc 2018. All rights reserved.

For licensing, contact sales@weblinc.com.
