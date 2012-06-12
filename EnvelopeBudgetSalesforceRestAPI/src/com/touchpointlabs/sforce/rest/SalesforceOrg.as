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

	public class SalesforceOrg
	{

		public function SalesforceOrg(consumerKey : String, consumerSecret : String, version : String)
		{
			this._consumerKey = consumerKey;
			this._consumerSecret = consumerSecret;
			this._version = version;
		}


		public function get url() : String
		{
			return _url;
		}


		public function set url(value : String) : void
		{
			_url = value;
		}


		public function get accessToken() : String
		{
			return _accessToken;
		}


		public function set accessToken(token : String) : void
		{
			this._accessToken = token;
		}


		public function get apiVersion() : String
		{
			return _version;
		}


		public function get consumerKey() : String
		{
			return _consumerKey;
		}


		public function get consumerSecret() : String
		{
			return _consumerSecret;
		}

		private var _consumerKey : String;
		private var _consumerSecret : String;
		private var _version : String;
		private var _accessToken : String;
		private var _url : String;

	}
}
