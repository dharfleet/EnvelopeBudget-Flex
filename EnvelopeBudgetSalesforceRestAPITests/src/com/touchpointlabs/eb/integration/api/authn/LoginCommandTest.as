/**
 Copyright © 2012 Daniel Harfleet. All Rights Reserved.

  Redistribution and use in source and binary forms, with or without modification, are
  permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice, this list
  of conditions and the following disclaimer.

  2. Redistributions in binary form must reproduce the above copyright notice, this
  list of conditions and the following disclaimer in the documentation and/or other
  materials provided with the distribution.

  3. The name of the author may not be used to endorse or promote products derived from
  this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY The Copyright Holder "AS IS" AND ANY EXPRESS OR IMPLIED
  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
  AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
  IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package com.touchpointlabs.eb.integration.api.authn
{
	import asmock.framework.Expect;
	import asmock.framework.MockRepository;
	import asmock.framework.constraints.Is;
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.SalesforceOrg;

	import mx.rpc.http.HTTPService;
	import mx.rpc.http.test.HTTPServiceStub;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;

	public class LoginCommandTest
	{

		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([SalesforceOrg, HTTPService, UserCredentials, Logger, LogFactory]);


		private var mockRepository : MockRepository;

		private var organizationMock : SalesforceOrg;
		private var httpServiceMock : HTTPService;

		private var headersFixture : Object
		private var consumerKeyFixture : String;
		private var consumerSecretFixture : String;
		private var instanceUrlFixture : String;
		private var apiVersionFixture : String;
		private var logFactory : LogFactory;

		private var command : JsonLoginCommand;


		[Before]
		public function setUp() : void
		{
			mockRepository = new MockRepository();
			logFactory = LoggingSupport.mockLogger();
			organizationMock = SalesforceOrg(mockRepository.createStrict(SalesforceOrg, [null, null, null]));
			httpServiceMock = HTTPService(mockRepository.createStrict(HTTPService));
			headersFixture = new Object();
		}


		[After]
		public function tearDown() : void
		{
			headersFixture = null;
			httpServiceMock = null;
			organizationMock = null;
			mockRepository = null;
		}


		[Test]
		public function testConstructor() : void
		{
			prepareConstructorExpectations();

			mockRepository.replayAll();
			command = new JsonLoginCommand(organizationMock, httpServiceMock, logFactory);

			assertEquals("the accept type must be set to json in the http header", "application/json", headersFixture["Accept"])

			mockRepository.verifyAll();
		}


		[Test(async)]
		public function testExecute() : void
		{
			var httpServiceStub : HTTPServiceStub = new HTTPServiceStub();
			httpServiceStub.delay = 100;

			consumerKeyFixture = "consumerKey";
			consumerSecretFixture = "consumerSecret";
			apiVersionFixture = "v24.0";
			instanceUrlFixture = "https://na14.salesforce.com";

			var usernameFixture : String = "username";
			var fullPasswordFixture : String = "fullPassword";

			var paramsFixture : Object = new Object();
			paramsFixture.grant_type = "password";
			paramsFixture.client_id = consumerKeyFixture;
			paramsFixture.client_secret = consumerSecretFixture;
			paramsFixture.username = usernameFixture;
			paramsFixture.password = fullPasswordFixture;

			var organizationFixture : SalesforceOrg = new SalesforceOrg(consumerKeyFixture, consumerSecretFixture, apiVersionFixture);


			var httpResultFixture : String = "{\"id\":\"https://login.salesforce.com/id/jfds89fasf89d9ds8ffhdfoUII9ddddjji9dh\",\"issued_at\":\"1338475075398\",\"instance_url\":\"" + instanceUrlFixture + "\",\"signature\":\"JKDFKASKKKJKJKJJKKJKkljhiHGIjkkhhi89huhhjhjd\",\"access_token\":\"accessToken\"}";

			var credentialsMock : UserCredentials = UserCredentials(mockRepository.createStrict(UserCredentials, [null, null, null]));


			mockRepository.ordered(function() : void
			{

				Expect.call(credentialsMock.username).returnValue(usernameFixture);
				Expect.call(credentialsMock.fullPassword).returnValue(fullPasswordFixture);

			});

			mockRepository.replayAll();

			httpServiceStub.result(paramsFixture, {"Accept": "application/json"}, "POST", httpResultFixture);

			command = new JsonLoginCommand(organizationFixture, httpServiceStub, logFactory);


			command.execute(function(result : Object) : void
			{
				assertThat(result, instanceOf(SalesforceOrg));

				var organization : SalesforceOrg = SalesforceOrg(result);

				assertThat("accessToken", equalTo(organization.accessToken));
				assertThat("v24.0", equalTo(organization.apiVersion));
				assertThat("consumerKey", equalTo(organization.consumerKey));
				assertThat("consumerSecret", equalTo(organization.consumerSecret));
				assertThat(instanceUrlFixture, equalTo(organization.url));
			}, credentialsMock);

			mockRepository.verifyAll();
		}


		[Test(async)]
		public function testExecuteAlreadyLoggedIn() : void
		{
			prepareConstructorExpectations();

			consumerKeyFixture = "consumerKey";
			consumerSecretFixture = "consumerSecret";
			apiVersionFixture = "v24.0";

			organizationMock = SalesforceOrg(mockRepository.createStrict(SalesforceOrg, [consumerKeyFixture, consumerSecretFixture, apiVersionFixture]));

			var credentialsMock : UserCredentials = UserCredentials(mockRepository.createStrict(UserCredentials, [null, null, null]));

			Expect.call(organizationMock.accessToken).returnValue("alreadyHeld");

			mockRepository.replayAll();

			command = new JsonLoginCommand(organizationMock, httpServiceMock, logFactory);


			command.execute(function(result : Object) : void
			{
				assertEquals(result, organizationMock);
			}, credentialsMock);

			mockRepository.verifyAll();
		}


		private function prepareConstructorExpectations() : void
		{
			headersFixture = new Object();
			Expect.call(httpServiceMock.url = null).constraints([Is.equal("https://login.salesforce.com/services/oauth2/token")]);
			Expect.call(httpServiceMock.method = null).constraints([Is.equal("POST")]);
			Expect.call(httpServiceMock.resultFormat = null).constraints([Is.equal("text")]);
			Expect.call(httpServiceMock.headers).returnValue(headersFixture);
		}

	}
}
