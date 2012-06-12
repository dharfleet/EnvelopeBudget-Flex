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
package com.touchpointlabs.sforce.rest
{
	import flexunit.framework.Assert;

	import org.flexunit.asserts.assertEquals;

	public class SalesforceOrgTest
	{

		private var salesforceOrg : SalesforceOrg;


		[Test]
		public function testConsumerKey() : void
		{
			var consumerKeyFixture : String = "uihw489.gwehroigug.ahfg48t4hgarewihgwia.HOHFGI*£(^£(*590";

			salesforceOrg = new SalesforceOrg(consumerKeyFixture, null, null);

			assertEquals(consumerKeyFixture, salesforceOrg.consumerKey);
		}


		[Test]
		public function testConsumerSecret() : void
		{
			var consumerSecretFixture : String = "djiafj098eu3io()UOK*(";

			salesforceOrg = new SalesforceOrg(null, consumerSecretFixture, null);

			assertEquals(consumerSecretFixture, salesforceOrg.consumerSecret);
		}


		[Test]
		public function testApiVersion() : void
		{
			var apiVersionFixture : String = "v25.0";

			salesforceOrg = new SalesforceOrg(null, null, apiVersionFixture);

			assertEquals(apiVersionFixture, salesforceOrg.apiVersion);
		}


		[Test]
		public function testSalesforceOrg() : void
		{
			var consumerKeyFixture : String = "azAZ10!@£$%^&*()_-+=,.:|\"";
			var consumerSecretFixture : String = "dsuf89eur*Y*(HhF8989.<>";
			var apiVersionFixture : String = "v27.1.2";

			salesforceOrg = new SalesforceOrg(consumerKeyFixture, consumerSecretFixture, apiVersionFixture);

			assertEquals("consumerKeyFixture", consumerKeyFixture, salesforceOrg.consumerKey);
			assertEquals("consumerSecretFixture", consumerSecretFixture, salesforceOrg.consumerSecret);
			assertEquals("apiVersionFixture", apiVersionFixture, salesforceOrg.apiVersion);
		}


		[Test]
		public function testUrl() : void
		{
			var urlFixture : String = "https://na14.salesforce.com";

			salesforceOrg = new SalesforceOrg(null, null, null);
			salesforceOrg.url = urlFixture;

			assertEquals(urlFixture, salesforceOrg.url);
		}


		[Test]
		public function testAccessToken() : void
		{
			var accessTokenFixture : String = "A!093NK930GJOIJG92034UT3944209";

			salesforceOrg = new SalesforceOrg(null, null, null);
			salesforceOrg.accessToken = accessTokenFixture;

			assertEquals(accessTokenFixture, salesforceOrg.accessToken);
		}
	}
}
