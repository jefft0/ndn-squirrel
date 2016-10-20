/**
 * Copyright (C) 2016 Regents of the University of California.
 * @author: Jeff Thompson <jefft0@remap.ucla.edu>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * A copy of the GNU Lesser General Public License is in the file COPYING.
 */

// Use a hard-wired secret for testing. In a real application the signer
// ensures that the verifier knows the shared key and its keyName.
HMAC_KEY <- Blob(Buffer([
   0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
  16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31
]), false);

/**
 * This is called by the library when a Data packet is received for the
 * expressed Interest. Print the Data packet name and content to the console.
 */
function onData(interest, data)
{
  consoleLog("Got data packet with name " + data.getName().toUri());
  consoleLog(data.getContent().toRawStr());

  if (KeyChain.verifyDataWithHmacWithSha256(data, HMAC_KEY))
    consoleLog("Data signature verification: VERIFIED");
  else
    consoleLog("Data signature verification: FAILED");
}

/**
 * Create a Face to the Imp device and express an Interest with the onData
 * callback which prints the content to the console. You should run this on
 * the Agent, and run test-imp-publish-async.device.nut on the Imp Device.
 */
function testConsume()
{
  local face = Face
    (SquirrelObjectTransport(), SquirrelObjectTransportConnectionInfo(device));

  local name = Name("/testecho");
  local word = "hello";
  name.append(word);
  consoleLog("Express name " + name.toUri());
  face.expressInterest(name, onData);
}

// Use a wakeup delay to let the Agent connect to the Device.
imp.wakeup(1, function() { testConsume(); });
