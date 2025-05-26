
//////////////////////////////////////////////////////////////////////////////////
// MIT License
//
// Copyright (c) 2020 Vicon Motion Systems Ltd
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//////////////////////////////////////////////////////////////////////////////////
#pragma once

/// \file
/// Contains the details declaration of the ViconCGStream::VCentroids class.

#include "Enum.h"
#include <StreamCommon/Buffer.h>

namespace ViconCGStreamDetail
{
//-------------------------------------------------------------------------------------------------

/// Contains the circle position, radius and accuracy
class VCentroids_Centroid
{
public:
  /// Circle position
  ViconCGStreamType::Double m_Position[ 2 ];

  /// Circle radius
  ViconCGStreamType::Double m_Radius;

  /// Circle accuracy
  ViconCGStreamType::Double m_Accuracy;
  
  // Equality operator
  bool operator == ( const VCentroids_Centroid & i_rOther ) const
  {
    return m_Position[ 0 ] == i_rOther.m_Position[ 0 ] &&
           m_Position[ 1 ] == i_rOther.m_Position[ 1 ] &&
           m_Radius == i_rOther.m_Radius &&
           m_Accuracy == i_rOther.m_Accuracy;
  }
  
  /// Read function.
  bool Read( const ViconCGStreamIO::VBuffer & i_rBuffer )
  {
    return i_rBuffer.Read( m_Position ) &&
           i_rBuffer.Read( m_Radius ) &&
           i_rBuffer.Read( m_Accuracy );
  }
    
  /// Write function.
  void Write( ViconCGStreamIO::VBuffer & i_rBuffer ) const
  {
    i_rBuffer.Write( m_Position );
    i_rBuffer.Write( m_Radius );
    i_rBuffer.Write( m_Accuracy );
  }     
};  

//-------------------------------------------------------------------------------------------------
};

