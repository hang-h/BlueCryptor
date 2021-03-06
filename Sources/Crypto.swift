//
//  Crypto.swift
//  Cryptor
//
// 	Licensed under the Apache License, Version 2.0 (the "License");
// 	you may not use this file except in compliance with the License.
// 	You may obtain a copy of the License at
//
// 	http://www.apache.org/licenses/LICENSE-2.0
//
// 	Unless required by applicable law or agreed to in writing, software
// 	distributed under the License is distributed on an "AS IS" BASIS,
// 	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// 	See the License for the specific language governing permissions and
// 	limitations under the License.
//

import Foundation

///
/// Implements a simplified API for calculating digests over single buffers
///
public protocol CryptoDigest {
	
    /// Calculates a message digest
    func digest(using algorithm: Digest.Algorithm) -> Self
}

///
/// Extension to the CryptoDigest to return the digest appropriate to the selected algorithm.
///
extension CryptoDigest {
	
    /// An MD2 digest of this object
    public var md2: Self {
		return self.digest(using: .md2)
	}
	
    /// An MD4 digest of this object
    public var md4: Self {
		return self.digest(using: .md4)
	}
	
    /// An MD5 digest of this object
    public var md5: Self {
		return self.digest(using: .md5)
 	}
	
    /// An SHA1 digest of this object
    public var sha1: Self {
		return self.digest(using: .sha1)
	}
	
    /// An SHA224 digest of this object
    public var sha224: Self {
		return self.digest(using: .sha224)
	}
	
    /// An SHA256 digest of this object
    public var sha256: Self {
		return self.digest(using: .sha256)
	}
	
    /// An SHA384 digest of this object
    public var sha384: Self {
		return self.digest(using: .sha384)
	}
	
    /// An SHA512 digest of this object
    public var sha512: Self {
		return self.digest(using: .sha512)
	}
}

///
/// Extension for NSData to return an NSData object containing the digest.
///
extension NSData: CryptoDigest {	
    ///
    /// Calculates the Message Digest for this data.
    /// 
    /// - Parameter algorithm: The digest algorithm to use
	///
    /// - Returns: An `NSData` object containing the message digest
	///
	/// - Note: Not supported on Linux due to differences in the `NSData` Foundation API.
	///
    public func digest(using algorithm: Digest.Algorithm) -> Self {
		
		#if os(OSX)
			
        	// This force unwrap may look scary but for CommonCrypto this cannot fail.
	        // The API allows for optionals to support the OpenSSL implementation which can.
			let result = (Digest(using: algorithm).update(data: self)?.final())!
        	let data = self.dynamicType.init(bytes: result, length: result.count)
	        return data
	
		#elseif os(Linux)
			
			fatalError("This API currently not supported on Linux.")
			
		#endif
    }
}

///
/// Extension for String to return a String containing the digest.
///
extension String: CryptoDigest {
    ///
    /// Calculates the Message Digest for this string.
    /// The string is converted to raw data using UTF8.
    ///
    /// - Parameter algorithm: The digest algorithm to use
	///
    /// - Returns: A hex string of the calculated digest
    ///
    public func digest(using algorithm: Digest.Algorithm) -> String {
		
        // This force unwrap may look scary but for CommonCrypto this cannot fail.
        // The API allows for optionals to support the OpenSSL implementation which can.
		let result = (Digest(using: algorithm).update(string: self as String)?.final())!
		return CryptoUtils.hexString(from: result)
		
    }
}
