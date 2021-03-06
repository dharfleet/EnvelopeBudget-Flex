/**
 Copyright (c) 2010 Brian LeGros

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/
package mx.rpc.http.test
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.IResponder;
	import mx.rpc.events.AbstractEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	/**
	 * Idea borrowed from Sonke Rohde @ http://soenkerohde.com/2008/10/conditional-compilation-to-mock-with-swiz/
	 **/
	public class HTTPServiceStub extends HTTPService
	{
		private var _resultData : Array;

		//default num of milliseconds to wait before dispatching events
		//don't put too low otherwise your token responders may not be registered
		public var delay : Number = 500;

		private var token : AsyncToken;
		private var parameters : Object;

		public function HTTPServiceStub(rootURL : String=null, destination : String=null)
		{
			super(rootURL, destination);
			_resultData = [];
		}

		public function result(parameters : Object, headers : Object=null, method : String="GET", data : *=null) : void
		{
			_resultData.push(new HTTPServiceSignature(parameters, headers, method, data));
		}

		public function fault(parameters : Object, headers : Object=null, method : String="GET", code : String=null, string : String=null, detail : String=null) : void
		{
			var fault : Fault = new Fault(code, string, detail);
			this.result(parameters, headers, method, fault);
		}

		override public function send(parameters : Object=null) : AsyncToken
		{
			return configureResponseTimer(parameters);
		}

		private function configureResponseTimer(parameters : Object) : AsyncToken
		{
			token = new AsyncToken(null);
			this.parameters = parameters;

			//use a time to give time for the caller to map responders to the asyncToken
			var timer : Timer = new Timer(this.delay, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimer);

			timer.start();

			return token;
		}

		private function handleTimer(event : TimerEvent) : void
		{
			//clean-up
			event.target.removeEventListener(TimerEvent.TIMER_COMPLETE, handleTimer);

			//find matching signature
			var result : Object = findSignatureResult(this.parameters, this.headers, this.method);
			var resultEvent : AbstractEvent = generateEvent(result);

			//loop over all responders to emulate a successful call being made
			for each (var responder : IResponder in token.responders)
			{
				var response : Function = result is Fault ? responder.fault : responder.result;
				response.apply(null, [resultEvent]);
			}

			//dispatch event to service
			dispatchEvent(resultEvent);
		}

		private function findSignatureResult(parameters : Object, headers : Object, method : String) : Object
		{
			var found : HTTPServiceSignature = null;

			for each (var signature : HTTPServiceSignature in _resultData)
			{
				if (signature.matches(parameters, headers, method))
				{
					found = signature;
					break;
				}
			}

			if (!found)
			{
				throw new Error("No signature found for this call.");
			}

			return found.result;
		}

		private function generateEvent(result : Object) : AbstractEvent
		{
			if (result is Fault)
			{
				return new FaultEvent(FaultEvent.FAULT, false, true, result as Fault, token);
			}
			else
			{
				return new ResultEvent(ResultEvent.RESULT, false, true, result, token);
			}
		}
	}
}
