
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
/// Contains the declaration of the ViconCGStream::VApplicationInfo class.

#include "Item.h"

namespace ViconCGStream
{
//-------------------------------------------------------------------------------------------------

/// Contains information about specific application settings that relate to the datastream
class VApplicationInfo : public VItem
{
public:

  enum EAxisOrientation : ViconCGStreamType::Char
  {
    EZUp,
    EYUp
  };

  /// Default construct this to have Z-up orientation, to maintain back compatibility with old servers
  VApplicationInfo() : m_AxisOrientation( EZUp ) {}

  /// A transformation matrix representing the axis orientation of the application
  EAxisOrientation m_AxisOrientation;

  /// Equality operator
  bool operator == ( const VApplicationInfo& i_rOther ) const
  {
    return m_AxisOrientation == i_rOther.m_AxisOrientation;
  }

  /// Object type enum.
  virtual ViconCGStreamType::Enum TypeID() const
  {
    return ViconCGStreamEnum::ApplicationInfo;
  }
  
  /// Filter ID
  virtual ViconCGStreamType::UInt32 FilterID() const
  {
    return FILTER_NA;
  }

  /// Read function.
  virtual bool Read( const ViconCGStreamIO::VBuffer & i_rBuffer )
  {
    return i_rBuffer.Read( m_AxisOrientation ) ;
  }

  /// Write function.
  virtual void Write( ViconCGStreamIO::VBuffer & i_rBuffer ) const
  {
    i_rBuffer.Write( m_AxisOrientation );
  }

};

//-------------------------------------------------------------------------------------------------
};

namespace ViconCGStreamIO
{
//-------------------------------------------------------------------------------------------------

template<>
struct VIsPod< ViconCGStream::VApplicationInfo::EAxisOrientation >
{
  enum
  {
    Answer = 1
  };
};

//-------------------------------------------------------------------------------------------------
};
