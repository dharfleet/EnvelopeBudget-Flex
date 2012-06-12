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
package mx.rpc.test
{
	import org.hamcrest.Matcher;
	import org.hamcrest.date.dateEqual;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.text.re;


	/**
	 * Utility used to share behavior for equality used in stub signatures.
	 */
	public class EqualityUtil
	{
		/**
		 * Borrowed from mockolate's MockingCouverture:
		 * http://github.com/drewbourne/mockolate/blob/master/mockolate/src/mockolate/ingredients/MockingCouverture.as
		 */
		public static function valueToMatcher(signatureValue : *) : Matcher
		{
			var matcher : Matcher = equalTo(signatureValue);

			if (signatureValue is RegExp)
			{
				matcher = re(signatureValue as RegExp);
			}
			else if (signatureValue is Date)
			{
				matcher = dateEqual(signatureValue);
			}
			else if (signatureValue is Class)
			{
				matcher = instanceOf(signatureValue);
			}
			else if (signatureValue is Matcher)
			{
				matcher = signatureValue as Matcher;
			}

			return matcher;
		}
	}
}
