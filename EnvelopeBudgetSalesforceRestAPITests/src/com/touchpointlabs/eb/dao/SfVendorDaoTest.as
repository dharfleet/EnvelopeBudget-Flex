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
package com.touchpointlabs.eb.dao
{
	import asmock.framework.Expect;
	import asmock.framework.MockRepository;
	import asmock.framework.SetupResult;
	import asmock.framework.constraints.Is;
	import asmock.integration.flexunit.IncludeMocksRule;

	import com.touchpointlabs.eb.domain.entity.Vendor;
	import com.touchpointlabs.eb.integration.api.CommandContext;
	import com.touchpointlabs.eb.integration.api.authn.LoginCommand;
	import com.touchpointlabs.eb.integration.api.authn.LoginCommandFactory;
	import com.touchpointlabs.eb.integration.api.authn.UserCredentials;
	import com.touchpointlabs.eb.integration.api.vendor.CreateVendorCommand;
	import com.touchpointlabs.eb.integration.api.vendor.CreateVendorCommandFactory;
	import com.touchpointlabs.eb.integration.api.vendor.GetVendorCommand;
	import com.touchpointlabs.eb.integration.api.vendor.GetVendorCommandFactory;
	import com.touchpointlabs.eb.integration.api.vendor.ListVendorsCommand;
	import com.touchpointlabs.eb.integration.api.vendor.ListVendorsCommandFactory;
	import com.touchpointlabs.eb.utility.LoggingSupport;
	import com.touchpointlabs.logging.LogFactory;
	import com.touchpointlabs.logging.Logger;
	import com.touchpointlabs.sforce.rest.SalesforceOrg;

	import mx.collections.ArrayCollection;
	import mx.collections.IList;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertNull;
	import org.hamcrest.collection.arrayWithSize;
	import org.hamcrest.collection.everyItem;
	import org.hamcrest.collection.hasItems;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperty;


	public class SfVendorDaoTest
	{
		[Rule]
		public var includeMocks : IncludeMocksRule = new IncludeMocksRule([SalesforceOrg, UserCredentials, LoginCommandFactory, ListVendorsCommandFactory, CreateVendorCommandFactory, GetVendorCommandFactory, Vendor, LoginCommand, CreateVendorCommand, ListVendorsCommand, GetVendorCommand, Logger, LogFactory]);


		private var mockRepository : MockRepository;

		private var organization : SalesforceOrg;
		private var credentials : UserCredentials;
		private var loginCommandFactory : LoginCommandFactory;
		private var loginCommand : LoginCommand;
		private var createVendorCommandFactory : CreateVendorCommandFactory;
		private var createVendorCommand : CreateVendorCommand;
		private var getVendorCommandFactory : GetVendorCommandFactory;
		private var getVendorCommand : GetVendorCommand;
		private var listVendorsCommandFactory : ListVendorsCommandFactory;
		private var listVendorsCommand : ListVendorsCommand;
		private var logFactory : LogFactory;

		private var dao : SfVendorDao;


		[Before]
		public function setUp() : void
		{
			mockRepository = new MockRepository();
			logFactory = LoggingSupport.mockLogger();

			organization = SalesforceOrg(mockRepository.createStrict(SalesforceOrg, [null, null, null]));
			credentials = UserCredentials(mockRepository.createStrict(UserCredentials, [null, null, null]));

			loginCommandFactory = LoginCommandFactory(mockRepository.createStrict(LoginCommandFactory));
			loginCommand = LoginCommand(mockRepository.createStrict(LoginCommand));
			SetupResult.forCall(loginCommandFactory.newLoginCommand()).returnValue(loginCommand);

			createVendorCommandFactory = CreateVendorCommandFactory(mockRepository.createStrict(CreateVendorCommandFactory));
			createVendorCommand = CreateVendorCommand(mockRepository.createStrict(CreateVendorCommand, [null, logFactory]));
			SetupResult.forCall(createVendorCommandFactory.newCreateVendorCommand()).returnValue(createVendorCommand);

			listVendorsCommandFactory = ListVendorsCommandFactory(mockRepository.createStrict(ListVendorsCommandFactory));
			listVendorsCommand = ListVendorsCommand(mockRepository.createStrict(ListVendorsCommand, [null, logFactory]));
			SetupResult.forCall(listVendorsCommandFactory.newListVendorsCommand()).returnValue(listVendorsCommand);

			getVendorCommandFactory = GetVendorCommandFactory(mockRepository.createStrict(GetVendorCommandFactory));
			getVendorCommand = GetVendorCommand(mockRepository.createStrict(GetVendorCommand, [null, logFactory]));
			SetupResult.forCall(getVendorCommandFactory.newGetVendorCommand()).returnValue(getVendorCommand);
		}


		[After]
		public function tearDown() : void
		{
			mockRepository = null;
			loginCommandFactory = null;
			loginCommand = null;
			createVendorCommandFactory = null;
			createVendorCommand = null;
			listVendorsCommandFactory = null;
			listVendorsCommand = null;
			organization = null;
			credentials = null;
			dao = null;
		}


		[Test]
		public function testConstructor() : void
		{
			mockRepository.replayAll();

			dao = new SfVendorDao(organization, credentials, loginCommandFactory, createVendorCommandFactory, listVendorsCommandFactory, getVendorCommandFactory, logFactory);

			mockRepository.verifyAll();
		}


		[Test]
		public function testCreate() : void
		{
			var vendorNameFixture : String = "John Lewis";
			var vendorIdFixture : String = "AAaijoaifij.did";
			var vendorFixture : Vendor = Vendor(mockRepository.createStrict(Vendor));
			SetupResult.forCall(vendorFixture.name).returnValue(vendorNameFixture);

			var listToAddResultTo : IList = new ArrayCollection();

			Expect.call(loginCommand.execute(null, null)).constraints([Is.typeOf(Function), Is.equal(credentials)]).doAction(function(callback : Function, credentials : UserCredentials) : void
			{
				callback(organization);
			});

			Expect.call(createVendorCommand.execute(null, null, null)).constraints([Is.typeOf(Function), Is.typeOf(SalesforceOrg), Is.typeOf(CommandContext)]).doAction(function(callback : Function, org : SalesforceOrg, context : CommandContext) : void
			{
				callback(vendorIdFixture);
			});

			Expect.call(getVendorCommand.execute(null, null, null)).constraints([Is.typeOf(Function), Is.typeOf(SalesforceOrg), Is.typeOf(CommandContext)]).doAction(function(callback : Function, org : SalesforceOrg, context : CommandContext) : void
			{
				callback(vendorFixture);
			});

			mockRepository.replayAll();
			dao = new SfVendorDao(organization, credentials, loginCommandFactory, createVendorCommandFactory, listVendorsCommandFactory, getVendorCommandFactory, logFactory);

			dao.create(vendorNameFixture, listToAddResultTo);

			assertThat(listToAddResultTo, arrayWithSize(1));
			assertThat(listToAddResultTo, everyItem(isA(Vendor)));
			assertThat(listToAddResultTo.getItemAt(0), hasProperty("name", equalTo(vendorNameFixture)));

			mockRepository.verifyAll();
		}


		[Test]
		public function testFindAll() : void
		{

			var vendor1 : Vendor = Vendor(mockRepository.createStrict(Vendor));
			SetupResult.forCall(vendor1.id).returnValue(1);
			SetupResult.forCall(vendor1.name).returnValue("Starbucks");

			var vendor2 : Vendor = Vendor(mockRepository.createStrict(Vendor));
			SetupResult.forCall(vendor2.id).returnValue(2);
			SetupResult.forCall(vendor2.name).returnValue("Costa Coffee");

			var vendor3 : Vendor = Vendor(mockRepository.createStrict(Vendor));
			SetupResult.forCall(vendor3.id).returnValue(3);
			SetupResult.forCall(vendor3.name).returnValue("Urban Coffee");

			var all : IList = new ArrayCollection([vendor1, vendor2, vendor3]);

			Expect.call(loginCommand.execute(null, null)).constraints([Is.typeOf(Function), Is.equal(credentials)]).doAction(function(callback : Function, credentials : UserCredentials) : void
			{
				callback(organization);
			});

			Expect.call(listVendorsCommand.execute(null, null, null)).constraints([Is.typeOf(Function), Is.typeOf(SalesforceOrg), Is.typeOf(CommandContext)]).doAction(function(callback : Function, org : SalesforceOrg, context : CommandContext) : void
			{
				callback(all);
			});

			mockRepository.replayAll();

			dao = new SfVendorDao(organization, credentials, loginCommandFactory, createVendorCommandFactory, listVendorsCommandFactory, getVendorCommandFactory, logFactory);

			var listToPopulate : IList = new ArrayCollection();

			dao.findAll(listToPopulate);

			mockRepository.verifyAll();

			assertThat(listToPopulate, arrayWithSize(3));
			assertThat(listToPopulate, everyItem(isA(Vendor)));
			assertThat(listToPopulate, hasItems(equalTo(vendor1), equalTo(vendor2), equalTo(vendor3)));
		}


		[Test]
		public function testFindById() : void
		{
			mockRepository.replayAll();

			dao = new SfVendorDao(organization, credentials, loginCommandFactory, createVendorCommandFactory, listVendorsCommandFactory, getVendorCommandFactory, logFactory);
			var nullDueToNotImplemented : Vendor = null;
			assertNull("this method is not implemented for the Force.com solution", nullDueToNotImplemented);
			mockRepository.verifyAll();

		}
	}
}
