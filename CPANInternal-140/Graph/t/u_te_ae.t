use Graph;

use Test::More tests => 26;

print "# creating graph\n";
my $gr = Graph->new( multiedged => 1 );

my $A = { name => 'A' };
my $B = { name => 'B' };
my $C = { name => 'C' };

print "# adding A => B\n";
add_edge ($gr,$A,$B);
dumper2($gr);

my @ids;

is($gr->successors  ('A'), 1);
is($gr->predecessors('A'), 0);

@ids = sort $gr->get_multiedge_ids('A', 'B');
is(@ids,   1);
is("@ids", "0");

is($gr->successors  ('B'), 0);
is($gr->predecessors('B'), 1);

@ids = sort $gr->get_multiedge_ids('A', 'B');
is(@ids,   1);
is("@ids", "0");

@ids = sort $gr->get_multiedge_ids('B', 'C');
is(@ids,   0);
is("@ids", "");

print "# adding C => B\n";
add_edge( $gr, $C, $B );
dumper2($gr);

is($gr->successors  ('A'), 1);
is($gr->predecessors('A'), 0);

@ids = sort $gr->get_multiedge_ids('A', 'B');
is(@ids,   1);
is("@ids", "0");

is($gr->successors  ('B'), 0);
is($gr->predecessors('B'), 2);

@ids = sort $gr->get_multiedge_ids('A', 'B');
is(@ids,   1);
is("@ids", "0");

@ids = sort $gr->get_multiedge_ids('C', 'B');
is(@ids,   1);
is("@ids", "0");

is($gr->successors  ('C'), 1);
is($gr->predecessors('C'), 0);

@ids = sort $gr->get_multiedge_ids('C', 'B');
is(@ids,   1);
is("@ids", "0");

@ids = sort $gr->get_multiedge_ids('B', 'C');
is(@ids,   0);
is("@ids", "");

sub add_edge
  {
  my ($g,$x,$y) = @_;

  my $edge_id = $g->add_edge_get_id($x->{name}, $y->{name});

  # work around bug in Graph v0.65 returning something else instead of '0'
  # on first call
  $edge_id = '0' if ref($edge_id);

  # comment this line out, and the dump changes
  $g->set_edge_attribute_by_id( $x->{name}, $y->{name}, $edge_id, "OBJ", {});

  }

sub dumper2
  {
  my @nodes = $gr->vertices();
  for my $n (sort @nodes)
    {
    print "# $n:\n";
    print "# successors   : ", scalar $gr->successors($n),"\n";
    print "# predecessors : ", scalar $gr->predecessors($n),"\n";
    my @suc = $gr->successors($n);
    for my $s (@suc)
      {
      print "# multiedge_ids $n => $s: ", join (", ", $gr->get_multiedge_ids($n, $s)),"\n";
      }
    my @pre = $gr->predecessors($n);
    for my $p (@pre)
      {
      print "# multiedge_ids $p => $n: ", join (", ", $gr->get_multiedge_ids($p, $n)),"\n";
      }
    }
  }
