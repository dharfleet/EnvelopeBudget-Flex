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
package com.touchpointlabs.eb.integration.api
{
	import flash.events.Event;

	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.utils.StringUtil;

	public class ContextKeyNotFoundFaultEvent extends FaultEvent
	{

		public static const TYPE : String = "ContextKeyNotFoundFaultEvent";

		public function ContextKeyNotFoundFaultEvent(key : String, bubbles : Boolean=false, cancelable : Boolean=true)
		{
			this._key = key;
			var faultDetail : String = StringUtil.substitute(detailTemplate, key);
			var fault : Fault = new Fault(code, _key, faultDetail);
			super(TYPE, bubbles, cancelable, fault);
		}


		override public function clone() : Event
		{
			return new ContextKeyNotFoundFaultEvent(_key, super.bubbles, super.cancelable);
		}


		private var _key : String;


		private static const code : String = "9001";
		private static const detailTemplate : String = "The CommandContext could not find the key with the name {0}";
	}
}
