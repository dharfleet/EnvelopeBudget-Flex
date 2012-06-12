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
	import mx.rpc.http.HTTPService;
	import mx.rpc.test.EqualityUtil;

	import org.hamcrest.Matcher;
	import org.hamcrest.object.equalTo;

	public class HTTPServiceSignature
	{
		private var paramsSignature : Object;
		private var headersSignature : Object;
		private var methodSignature : String;
		private var _result : Object;

		public function HTTPServiceSignature(params : Object, headers : Object=null, method : String="GET", result : Object=null)
		{
			this.paramsSignature = params;
			this.headersSignature = headers;
			this.methodSignature = method;
			this._result = result;
		}

		public function matches(paramsCall : Object, headersCall : Object, methodCall : String) : Boolean
		{
			var methodMatches : Boolean = equalTo(methodCall.toUpperCase()).matches(methodSignature);
			return objectsMatch(paramsSignature, paramsCall) && objectsMatch(headersSignature, headersCall) && methodMatches;
		}

		private function objectsMatch(signature : Object, call : Object) : Boolean
		{
			if (signature === call) //same instance?
			{
				return true;
			}

			if (!propertyLengthsMatch(signature, call))
			{
				return false;
			}

			for (var property : String in call)
			{
				if (!signature[property] && call[property]) //object property not in this signature
				{
					return false;
				}

				var matcher : Matcher = EqualityUtil.valueToMatcher(signature[property]);
				if (!matcher.matches(call[property]))
				{
					return false;
				}
			}

			return true;
		}

		private function propertyLengthsMatch(signature : Object, call : Object) : Boolean
		{
			var signatureCount : uint = 0;
			var callCount : uint = 0;
			var temp : String = null;

			for (temp in signature)
			{
				signatureCount++;
			}

			for (temp in call)
			{
				callCount++;
			}

			return signatureCount == callCount;
		}

		public function get result() : Object
		{
			return _result;
		}
	}
}
