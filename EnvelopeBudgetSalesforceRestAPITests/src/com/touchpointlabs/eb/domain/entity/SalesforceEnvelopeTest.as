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
package com.touchpointlabs.eb.domain.entity
{
	import org.flexunit.asserts.assertEquals;

	public class SalesforceEnvelopeTest
	{

		private var envelope : Envelope;
		private var jsonRecord : Object;


		[Before]
		public function setUp() : void
		{
			jsonRecord = {EnvelopeId__c: "1", Id: "AcAAAdhlhj389.3kl", Name: "Internet Costs"};
			envelope = new SalesforceEnvelope(jsonRecord);
		}


		[After]
		public function tearDown() : void
		{
			jsonRecord = null;
			envelope = null;
		}


		[Test]
		public function testId() : void
		{
			assertEquals(1, envelope.id);
		}


		[Test]
		public function testSfid() : void
		{
			var salesforceId : String = SalesforceEnvelope(envelope).sfid;

			assertEquals("AcAAAdhlhj389.3kl", salesforceId);
		}


		[Test]
		public function testName() : void
		{
			assertEquals("Internet Costs", envelope.name);
		}
	}
}
